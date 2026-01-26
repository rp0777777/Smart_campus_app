import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../features/issue_reporter/issue_reporter_screen.dart';
import '../features/attendance/attendance_screen.dart';
import '../services/gemini_service.dart';

class GeminiChatWidget extends StatefulWidget {
  const GeminiChatWidget({super.key});

  @override
  State<GeminiChatWidget> createState() => _GeminiChatWidgetState();
}

class _GeminiChatWidgetState extends State<GeminiChatWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"role": "ai", "content": "Hi! I'm Gemini. I'm your real AI assistant. How can I help you today? \n\nTry: 'Report an issue' or 'Mark attendance'."}
  ];
  bool _isTyping = false;

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    
    final userText = _controller.text;
    setState(() {
      _messages.add({"role": "user", "content": userText});
      _controller.clear();
      _isTyping = true;
    });

    try {
      final aiResponse = await GeminiService().getGeneralResponse(userText);
      
      VoidCallback? action;
      final lowerText = userText.toLowerCase();
      
      if (lowerText.contains("report") || lowerText.contains("issue") || lowerText.contains("broken") || lowerText.contains("leak")) {
        action = () {
           Navigator.pop(context); // Close chat
           Navigator.push(context, MaterialPageRoute(builder: (_) => const IssueReporterScreen()));
        };
      } else if (lowerText.contains("attendance") || lowerText.contains("present") || lowerText.contains("scan")) {
        action = () {
           Navigator.pop(context);
           Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen()));
        };
      }

      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({"role": "ai", "content": aiResponse});
        });
        
        if (action != null) {
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) action();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({"role": "ai", "content": "I'm having trouble connecting right now."});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.sparkles, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Text(
                  "Gemini Assistant", 
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)
                ),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? Theme.of(context).primaryColor : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isUser ? Radius.zero : null,
                        bottomLeft: !isUser ? Radius.zero : null,
                      ),
                    ),
                    child: Text(
                      msg['content']!,
                      style: GoogleFonts.outfit(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               child: Align(
                 alignment: Alignment.centerLeft,
                 child: Text("Gemini is typing...", style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
               ),
             ),
          Container(
            padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask anything...",
                      hintStyle: GoogleFonts.outfit(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(LucideIcons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

