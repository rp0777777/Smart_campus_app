import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../services/gemini_service.dart';

class ExamStressScreen extends StatefulWidget {
  const ExamStressScreen({super.key});

  @override
  State<ExamStressScreen> createState() => _ExamStressScreenState();
}

class _ExamStressScreenState extends State<ExamStressScreen> {
  String? _aiSuggestion;
  bool _isLoading = false;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _analyzeStress() async {
    setState(() {
      _isAnalyzing = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulate voice analysis

    setState(() {
      _isAnalyzing = false;
      _isLoading = true;
    });

    try {
      final response = await GeminiService().getMentalHealthResponse(
        "I'm feeling stressed about my upcoming exams. Can you help me with stress relief techniques and study strategies?",
        []
      );
      
      if (mounted) {
        setState(() {
          _aiSuggestion = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiSuggestion = "I'm having trouble connecting. Please try again.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stress Relief"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Voice Analysis Button
            GestureDetector(
              onTap: _isAnalyzing || _isLoading ? null : _analyzeStress,
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade50,
                  shape: BoxShape.circle,
                  boxShadow: _isAnalyzing 
                    ? [BoxShadow(color: Colors.deepOrange.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)]
                    : [],
                ),
                child: Icon(
                  _isAnalyzing ? LucideIcons.radio : LucideIcons.mic,
                  size: 80,
                  color: _isAnalyzing ? Colors.deepOrange : Colors.deepOrange.shade300,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _isAnalyzing ? "Analyzing your stress level..." : "Tap to get AI stress relief",
              style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _isAnalyzing 
                ? "Please wait while we analyze..." 
                : "Get personalized stress management tips",
              style: GoogleFonts.outfit(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            
            if (_isLoading) ...[
              const SizedBox(height: 32),
              const CircularProgressIndicator(color: Colors.deepOrange),
            ],

            if (_aiSuggestion != null && !_isLoading) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.deepOrange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.sparkles, color: Colors.deepOrange, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "AI Stress Relief Tips",
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _aiSuggestion!,
                      style: GoogleFonts.outfit(fontSize: 15, height: 1.6),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),
            // Quick Relief Options
            Text("Quick Relief Options", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildReliefCard(
              "Breathing Exercise",
              "4-7-8 technique for instant calm",
              LucideIcons.wind,
              Colors.blue,
              () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("4-7-8 Breathing", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                    content: Text(
                      "1. Breathe in for 4 seconds\n2. Hold for 7 seconds\n3. Exhale for 8 seconds\n\nRepeat 4 times",
                      style: GoogleFonts.outfit(fontSize: 16, height: 1.8),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Got it!"),
                      ),
                    ],
                  ),
                );
              },
            ),
            _buildReliefCard(
              "Study Break Timer",
              "Pomodoro technique: 25 min work, 5 min break",
              LucideIcons.timer,
              Colors.green,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Timer started! Take a break after 25 minutes."))
                );
              },
            ),
            _buildReliefCard(
              "Calming Music",
              "Lo-fi beats to help you focus",
              LucideIcons.music,
              Colors.purple,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Opening music player..."))
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReliefCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: GoogleFonts.outfit(fontSize: 13)),
        trailing: const Icon(LucideIcons.chevron_right, size: 16),
        onTap: onTap,
      ),
    );
  }
}

