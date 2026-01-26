import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../services/mock_database.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  @override
  Widget build(BuildContext context) {
    final slots = MockDatabase().getParkingSlots();

    return Scaffold(
      appBar: AppBar(title: const Text("Parking Finder")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegend(Colors.green, "Available"),
                _buildLegend(Colors.red, "Occupied"),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: slots.length,
              itemBuilder: (context, index) {
                final slot = slots[index];
                final isAvailable = slot['isAvailable'] as bool;
                final color = isAvailable ? Colors.green : Colors.red;
                
                return Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    border: Border.all(color: color, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(LucideIcons.car, color: color, size: 30),
                       const SizedBox(height: 12),
                       Text(
                         slot['id'], 
                         style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: color)
                       ),
                       Text(
                         slot['location'], 
                         style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600])
                       ),
                       const SizedBox(height: 4),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                         decoration: BoxDecoration(
                           color: color,
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: Text(
                           isAvailable ? "FREE" : "BUSY",
                           style: GoogleFonts.outfit(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                         ),
                       )
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Status is updated in real-time by Campus Admin",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.outfit()),
      ],
    );
  }
}

