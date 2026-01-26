import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../services/mock_database.dart';

class HostelScreen extends StatefulWidget {
  const HostelScreen({super.key});

  @override
  State<HostelScreen> createState() => _HostelScreenState();
}

class _HostelScreenState extends State<HostelScreen> {
  final _issueController = TextEditingController();
  double _severity = 1;
  String _selectedHostel = "Sahara";
  String _selectedRoom = "101";

  final List<String> _hostels = ["Sahara", "Siberia", "Sarovar", "Sagar"];
  final List<String> _rooms = List.generate(20, (i) => "${101 + i}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hostel Services"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hostel Selection
            Text("Select Hostel", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown.shade200),
              ),
              child: DropdownButton<String>(
                value: _selectedHostel,
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(LucideIcons.chevron_down, color: Colors.brown),
                items: _hostels.map((hostel) {
                  return DropdownMenuItem(
                    value: hostel,
                    child: Row(
                      children: [
                        const Icon(LucideIcons.house, color: Colors.brown, size: 20),
                        const SizedBox(width: 12),
                        Text(hostel, style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedHostel = value!),
              ),
            ),
            const SizedBox(height: 24),

            // Room Selection
            Text("Room Number", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown.shade200),
              ),
              child: DropdownButton<String>(
                value: _selectedRoom,
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(LucideIcons.chevron_down, color: Colors.brown),
                items: _rooms.map((room) {
                  return DropdownMenuItem(
                    value: room,
                    child: Text("Room $room", style: GoogleFonts.outfit()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedRoom = value!),
              ),
            ),
            const SizedBox(height: 32),

            // Complaint Section
            Text("Lodge a Complaint", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _issueController,
              decoration: InputDecoration(
                labelText: "Issue Description",
                hintText: "e.g., Water supply problem, AC not working...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(LucideIcons.pen_tool),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Text("Severity Level: ${_severity.toInt()}", style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
            Slider(
              value: _severity,
              min: 1,
              max: 5,
              divisions: 4,
              label: _severity.toInt().toString(),
              activeColor: Colors.brown,
              onChanged: (v) => setState(() => _severity = v),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_issueController.text.isNotEmpty) {
                    MockDatabase().addHostelComplaint({
                      "hostel": _selectedHostel,
                      "room": "Room $_selectedRoom",
                      "issue": _issueController.text,
                      "severity": _severity,
                      "time": DateTime.now().toIso8601String(),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Complaint lodged for $_selectedHostel - Room $_selectedRoom"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    _issueController.clear();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please describe the issue")),
                    );
                  }
                },
                icon: const Icon(LucideIcons.send),
                label: const Text("Submit Complaint"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }
}

