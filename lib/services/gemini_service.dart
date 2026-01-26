import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  static const String _apiKey = '***REMOVED***';
  GenerativeModel? _model;
  GenerativeModel? _mentalHealthModel;
  GenerativeModel? _studyPlannerModel;

  void initialize() {
    if (_model != null) return;
    
    final safetySettings = [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
    ];

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      safetySettings: safetySettings,
    );

    _mentalHealthModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      safetySettings: safetySettings,
      systemInstruction: Content.system("""You are Aurora, a compassionate and empathetic mental health companion for college students. 
Your role is to:
- Listen actively and validate their feelings
- Provide emotional support and encourage healthy coping
- Recognize when professional help might be needed
- Keep responses warm, concise (2-3 sentences), and supportive
Never diagnose or replace professional therapy."""),
    );

    _studyPlannerModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      safetySettings: safetySettings,
      systemInstruction: Content.system("""You are an intelligent study planning assistant for college students.
Your role is to:
- Create realistic, actionable study plans
- Break down complex topics into manageable tasks
- Provide study techniques and tips (3-4 bullet points)
Focus on being helpful and motivating."""),
    );
  }

  GenerativeModel get model {
    if (_model == null) initialize();
    return _model!;
  }

  // Mental Health Chat
  Future<String> getMentalHealthResponse(String userMessage, List<Map<String, String>> history) async {
    try {
      if (_mentalHealthModel == null) initialize();
      
      final List<Content> chatHistory = history.where((m) => m['content'] != null).map((msg) {
        return msg['role'] == 'user' 
            ? Content.text(msg['content']!) 
            : Content.model([TextPart(msg['content']!)]);
      }).toList();

      final chat = _mentalHealthModel!.startChat(history: chatHistory);
      final response = await chat.sendMessage(Content.text(userMessage));
      return response.text ?? "I'm here for you. Could you tell me more?";
    } catch (e) {
      print("Gemini Error (Mental Health): $e");
      return "I'm having a little trouble connecting right now, but I'm still listening. How else can I support you?";
    }
  }

  // Study Planner
  Future<String> getStudyPlannerResponse(String userRequest) async {
    try {
      if (_studyPlannerModel == null) initialize();
      final response = await _studyPlannerModel!.generateContent([Content.text(userRequest)]);
      return response.text ?? "I can help you plan that! What specific topics should we cover?";
    } catch (e) {
      print("Gemini Error (Study Planner): $e");
      return "I'm having trouble generating a plan right now. Let's try breaking it down into smaller steps first.";
    }
  }

  // General Gemini Chat
  Future<String> getGeneralResponse(String userMessage) async {
    try {
      final response = await model.generateContent([
        Content.text("You are Gemini, a helpful AI assistant for a Smart Campus app. Keep responses brief (1-2 sentences) and friendly.\n\nUser: $userMessage")
      ]);
      return response.text ?? "I can help with that! What do you need?";
    } catch (e) {
      print("Gemini Error (General): $e");
      return "I'm momentarily unavailable, but I'm still here to help with campus navigation and more!";
    }
  }
}


