import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Community Help")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDriveCard(
            context,
            "Beach Cleanup Drive",
            "NSS National Service Scheme",
            "Kuzhupilly Beach",
            Colors.blue,
            LucideIcons.waves,
          ),
          _buildDriveCard(
            context,
            "Compose Campus App",
            "GDG on Campus CUSAT",
            "IT Dept Hall",
            Colors.green,
            LucideIcons.code_xml,
          ),
          _buildDriveCard(
            context,
            "Tech Workshop Series",
            "IEEE CUSAT SB",
            "Seminar Hall",
            Colors.indigo,
            LucideIcons.zap,
          ),
        ],
      ),
    );
  }

  Widget _buildDriveCard(BuildContext context, String title, String org, String loc, Color color, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
               children: [
                 Container(
                   padding: const EdgeInsets.all(8),
                   decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                   child: Icon(icon, color: color, size: 20),
                 ),
                 const SizedBox(width: 12),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(org, style: GoogleFonts.outfit(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
                       Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                     ],
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 12),
             Row(
               children: [
                 const Icon(LucideIcons.map_pin, size: 14, color: Colors.grey),
                 const SizedBox(width: 4),
                 Text(loc, style: GoogleFonts.outfit(color: Colors.grey)),
               ],
             ),
             const SizedBox(height: 20),
             SizedBox(
               width: double.infinity,
               child: ElevatedButton.icon(
                 onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registered for $title!"))
                    );
                 }, 
                 icon: const Icon(LucideIcons.user_plus),
                 label: const Text("Join This Drive"),
                 style: ElevatedButton.styleFrom(
                   backgroundColor: color,
                   foregroundColor: Colors.white,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                   padding: const EdgeInsets.symmetric(vertical: 12),
                 ),
               ),
             )
          ],
        ),
      ),
    );
  }
}

