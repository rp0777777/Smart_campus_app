import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Campus Navigator"), elevation: 0),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/campus_map.png'),
                fit: BoxFit.cover,
                opacity: 0.3, // Soften the map for UI elements
              ),
            ),
          ),
          
          // Landmarks
          Positioned(top: 150, left: 100, child: _buildMarker("Library", Colors.blue)),
          Positioned(top: 250, right: 80, child: _buildMarker("A Block", Colors.orange)),
          Positioned(bottom: 200, left: 120, child: _buildMarker("Software Block", Colors.green)),
          Positioned(bottom: 150, right: 100, child: _buildMarker("NLB", Colors.purple)),
          Positioned(top: 400, left: 200, child: _buildMarker("You are here", Colors.red, isUser: true)),

          Positioned(
            top: 20, left: 16, right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for Labs, Libraries, Hostels...",
                  border: InputBorder.none,
                  prefixIcon: const Icon(LucideIcons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          
          Positioned(
            bottom: 30, right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoom",
                  onPressed: () {},
                  mini: true,
                  backgroundColor: Colors.white,
                  child: const Icon(LucideIcons.plus, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: "nav",
                  onPressed: () {},
                  backgroundColor: Colors.blue,
                  child: const Icon(LucideIcons.navigation, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(String label, Color color, {bool isUser = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]),
          child: Text(label, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 10, color: color)),
        ),
        Icon(isUser ? LucideIcons.circle_dot : LucideIcons.map_pin, color: color, size: isUser ? 20 : 30),
      ],
    );
  }
}

