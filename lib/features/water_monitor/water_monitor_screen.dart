import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaterMonitorScreen extends StatelessWidget {
  const WaterMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], 
      appBar: AppBar(title: const Text("Water Monitor"), backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildTank("A Block", 0.8),
            _buildTank("Software Block", 0.4),
            _buildTank("B Block", 0.6),
            _buildTank("C Block", 0.9),
            _buildTank("NLB", 0.2),
          ],
        ),
      ),
    );
  }

  Widget _buildTank(String name, double level) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FractionallySizedBox(
              heightFactor: level,
              child: Container(color: Colors.blue.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${(level * 100).toInt()}%", style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                Text(name, style: GoogleFonts.outfit(color: Colors.blue[800])),
              ],
            ),
          )
        ],
      ),
    );
  }
}

