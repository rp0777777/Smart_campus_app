import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class BusTrackingScreen extends StatelessWidget {
  const BusTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bus Tracking")),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/campus_map.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.blueGrey.withOpacity(0.2), 
                  BlendMode.dstATop,
                ),
              ),
            ),
            child: Stack(
              children: [
                Positioned(top: 80, left: 140, child: _buildBusMarker("KSRTC", Colors.red)),
                Positioned(bottom: 100, left: 60, child: _buildBusMarker("Feeder", Colors.green)),
                Positioned(top: 150, right: 80, child: _buildBusMarker("Electric", Colors.blue)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildRouteCard(
                  "Route A - CUSAT Metro Feeder",
                  "Arriving in 5 minutes",
                  Colors.green,
                ),
                _buildRouteCard(
                  "KSRTC - Pipeline Route",
                  "Coming in 1 hour",
                  Colors.orange,
                ),
                _buildRouteCard(
                  "Electric Feeder Bus",
                  "Arriving after 5 hours",
                  Colors.grey,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBusMarker(String name, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
          child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        Icon(LucideIcons.bus, color: color, size: 30),
      ],
    );
  }

  Widget _buildRouteCard(String name, String status, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(LucideIcons.bus, color: color)),
        title: Text(name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        subtitle: Text(status, style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.w600)),
        trailing: const Icon(LucideIcons.chevron_right),
      ),
    );
  }
}

