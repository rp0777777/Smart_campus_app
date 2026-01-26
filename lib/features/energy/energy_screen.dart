import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class EnergyScreen extends StatelessWidget {
  const EnergyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(title: const Text("Energy Grid", style: TextStyle(color: Colors.white)), backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.yellow[900], borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(LucideIcons.zap, size: 40, color: Colors.white),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Current Load", style: GoogleFonts.outfit(color: Colors.white70)),
                      Text("450 kW", style: GoogleFonts.outfit(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildDeviceRow("Library AC System", "Running", Colors.green),
            _buildDeviceRow("Street Lights", "Off", Colors.grey),
            _buildDeviceRow("Lab Equipment", "Standby", Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceRow(String name, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: GoogleFonts.outfit(color: Colors.white)),
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: color),
              const SizedBox(width: 8),
              Text(status, style: TextStyle(color: color)),
            ],
          )
        ],
      ),
    );
  }
}

