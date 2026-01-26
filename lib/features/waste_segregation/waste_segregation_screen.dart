import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';

class WasteSegregationScreen extends StatefulWidget {
  const WasteSegregationScreen({super.key});

  @override
  State<WasteSegregationScreen> createState() => _WasteSegregationScreenState();
}

class _WasteSegregationScreenState extends State<WasteSegregationScreen> {
  File? _scannedImage;

  Future<void> _captureWaste() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _scannedImage = File(image.path);
      });
      // Simulate AI analysis delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Analysis: Recyclable Plastic detected (Blue Bin)"))
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Waste Identifier", style: TextStyle(color: Colors.white)), 
        backgroundColor: Colors.transparent, 
        iconTheme: const IconThemeData(color: Colors.white)
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[900],
                    child: _scannedImage != null 
                      ? Image.file(_scannedImage!, fit: BoxFit.cover)
                      : const Icon(LucideIcons.camera, size: 64, color: Colors.grey),
                  ),
                ),
                if (_scannedImage == null)
                  Center(
                    child: Container(
                      height: 250, width: 250,
                      decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent, width: 2), borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                Positioned(
                  bottom: 40, left: 0, right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: _captureWaste,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30)),
                        child: Text(_scannedImage == null ? "Scan Object" : "Scan Again", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("How to Recycle:", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildLeged(Colors.green, "Biodegradable (Food, Paper)"),
                const SizedBox(height: 8),
                _buildLeged(Colors.blue, "Recyclable (Plastic, Glass)"),
                const SizedBox(height: 8),
                _buildLeged(Colors.red, "Hazardous (Batteries, Meds)"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLeged(Color color, String text) {
    return Row(children: [CircleAvatar(backgroundColor: color, radius: 6), const SizedBox(width: 12), Text(text, style: GoogleFonts.outfit(fontSize: 16))]);
  }
}

