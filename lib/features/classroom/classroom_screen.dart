import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../services/mock_database.dart';

class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  final List<String> _clubs = ["TinkerHub", "GDG", "IEEE", "IEDC", "NSS", "Aroha"];

  void _bookRoom(String roomNumber) async {
    String? selectedClub = _clubs[0];
    final TextEditingController nameController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Book Room $roomNumber", style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Your Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(LucideIcons.user),
                ),
              ),
              const SizedBox(height: 16),
              Text("Select Club / Organization", style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedClub,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: _clubs.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setModalState(() => selectedClub = v),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      MockDatabase().bookClassroom(roomNumber, nameController.text, selectedClub!);
                      setState(() {});
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Room $roomNumber booked for $selectedClub!")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Confirm Booking"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookings = MockDatabase().getClassroomBookings();

    return Scaffold(
      appBar: AppBar(title: const Text("Classroom Tracker")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8, // Showing 8 sample rooms
        itemBuilder: (context, index) {
          final roomNumber = "10${index + 1}";
          final booking = bookings.any((b) => b['room'] == roomNumber) 
              ? bookings.firstWhere((b) => b['room'] == roomNumber) 
              : null;
          final isFree = booking == null;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (isFree ? Colors.green : Colors.red).withOpacity(0.1),
                child: Icon(LucideIcons.door_open, color: isFree ? Colors.green : Colors.red),
              ),
              title: Text("Room $roomNumber", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              subtitle: Text(
                isFree 
                  ? "Available for Booking" 
                  : "Booked by ${booking['club']} (${booking['user']})",
                style: GoogleFonts.outfit(color: isFree ? Colors.green[700] : Colors.red[700]),
              ),
              trailing: isFree 
                ? ElevatedButton(
                    onPressed: () => _bookRoom(roomNumber),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, 
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ), 
                    child: const Text("Book")
                  )
                : const Icon(LucideIcons.lock, size: 16, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}

