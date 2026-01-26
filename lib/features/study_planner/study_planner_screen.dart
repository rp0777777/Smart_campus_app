import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../services/gemini_service.dart';

class StudyPlannerScreen extends StatefulWidget {
  const StudyPlannerScreen({super.key});

  @override
  State<StudyPlannerScreen> createState() => _StudyPlannerScreenState();
}

class _StudyPlannerScreenState extends State<StudyPlannerScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _aiResponse;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _tasks = [
    {"subject": "Data Structures", "task": "Finish Linked List Module", "priority": "High", "color": Colors.redAccent},
    {"subject": "Calculus II", "task": "Practice Integration Problems", "priority": "Medium", "color": Colors.orangeAccent},
    {"subject": "Physics Lab", "task": "Write Report for Exp 3", "priority": "Low", "color": Colors.greenAccent},
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _generateStudyPlan() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please describe what you need help with"))
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _aiResponse = null;
    });

    try {
      final response = await GeminiService().getStudyPlannerResponse(_controller.text.trim());
      if (mounted) {
        setState(() {
          _aiResponse = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiResponse = "I'm having trouble generating a plan. Please try again.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Study Planner"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // AI Input Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.deepPurple.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.sparkles, color: Colors.deepPurple, size: 20),
                    const SizedBox(width: 8),
                    Text("Ask AI for Study Help", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "e.g., Create a study plan for Data Structures exam in 2 weeks",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    suffixIcon: IconButton(
                      icon: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(LucideIcons.send, color: Colors.deepPurple),
                      onPressed: _isLoading ? null : _generateStudyPlan,
                    ),
                  ),
                  maxLines: 2,
                  onSubmitted: (_) => _generateStudyPlan(),
                ),
                if (_aiResponse != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.deepPurple.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.lightbulb, color: Colors.amber, size: 18),
                            const SizedBox(width: 8),
                            Text("AI Suggestion", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(_aiResponse!, style: GoogleFonts.outfit(fontSize: 14, height: 1.5)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Tasks List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your Tasks", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _tasks.add({
                            "subject": "New Task",
                            "task": "Add description",
                            "priority": "Medium",
                            "color": Colors.blueAccent
                          });
                        });
                      },
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text("Add"),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._tasks.map((task) => _buildTaskCard(
                  task["subject"],
                  task["task"],
                  task["priority"],
                  task["color"],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String subject, String task, String priority, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(LucideIcons.book, color: color, size: 18)
        ),
        title: Text(subject, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        subtitle: Text(task),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Text(
            priority,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

