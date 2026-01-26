import 'package:flutter/material.dart';
import '../../services/mock_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class EventManagerScreen extends StatefulWidget {
  const EventManagerScreen({super.key});

  @override
  State<EventManagerScreen> createState() => _EventManagerScreenState();
}

class _EventManagerScreenState extends State<EventManagerScreen> {
  final List<Map<String, dynamic>> _events = MockDatabase().getEvents();

  void _openRegistrationForm(String eventName) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController collegeController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24, right: 24, top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Register for $eventName", style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[900])),
              const SizedBox(height: 8),
              Text("Please fill out this form to participate.", style: GoogleFonts.outfit(color: Colors.grey[600])),
              const Divider(height: 40),
              
              _buildFormLabel("Full Name *"),
              TextField(
                controller: nameController,
                decoration: _formInputDecoration("Enter your name"),
              ),
              const SizedBox(height: 24),

              _buildFormLabel("Campus Email *"),
              TextField(
                controller: emailController,
                decoration: _formInputDecoration("yourname@cusat.ac.in"),
              ),
              const SizedBox(height: 24),

              _buildFormLabel("Department / College *"),
              TextField(
                controller: collegeController,
                decoration: _formInputDecoration("e.g. SOE, CUSAT"),
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      MockDatabase().registerForEvent(eventName, nameController.text);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Successfully registered for $eventName!"),
                          backgroundColor: Colors.blueAccent,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Submit Registration"),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _formInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Campus Events"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final e = _events[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(e['color'] as int).withOpacity(0.8),
                  ),
                  child: Center(
                    child: Icon(LucideIcons.sparkles, size: 60, color: Colors.white.withOpacity(0.5)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e['name'] as String, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(LucideIcons.calendar, size: 16, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Text(e['date'] as String, style: GoogleFonts.outfit(color: Colors.grey[700])),
                          const SizedBox(width: 24),
                          Icon(LucideIcons.map_pin, size: 16, color: Colors.red[700]),
                          const SizedBox(width: 8),
                          Text(e['loc'] as String, style: GoogleFonts.outfit(color: Colors.grey[700])),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _openRegistrationForm(e['name'] as String),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(e['color'] as int),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Register Now"),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

