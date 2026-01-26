import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../services/mock_database.dart';

class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  bool _isSharingLocation = false;

  void _triggerSOS() {
    MockDatabase().triggerSOS("Student (Roll: S-1234)", "Main Library Area");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("SOS Alert Sent! Security is notified in the Admin Panel."), 
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Safety Center")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _triggerSOS,
                child: Container(
                  height: 200, width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                    boxShadow: [
                      BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 20, spreadRadius: 10),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.bell_ring, color: Colors.white, size: 60),
                      const SizedBox(height: 8),
                      Text("SOS", style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text("Press for Immediate Help", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600)),
              Text("Alerts Security & Nearby Volunteers", style: GoogleFonts.outfit(color: Colors.grey)),
              const SizedBox(height: 40),
              SwitchListTile(
                title: Text("Share Live Location", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                subtitle: const Text("Allow security to track your location in real-time"),
                value: _isSharingLocation,
                onChanged: (v) {
                  setState(() => _isSharingLocation = v);
                  if (v) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Live Location Shared with Admin Panel"))
                    );
                  }
                },
                secondary: const Icon(LucideIcons.map_pin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

