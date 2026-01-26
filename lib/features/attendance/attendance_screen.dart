import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/mock_database.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  File? _selfie;
  bool _isMarking = false;

  Future<void> _takeSelfie() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (image != null) {
      setState(() {
        _selfie = File(image.path);
      });
    }
  }

  void _markAttendance() async {
    if (_selfie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Face Verification Required! Take a selfie.")),
      );
      return;
    }

    setState(() => _isMarking = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate AI scan

    MockDatabase().markAttendance("S-1234", "CS101", selfiePath: _selfie!.path);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attendance Marked: CS101 (Present)")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Attendance")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
             if (_selfie == null)
               _buildScanPlaceholder()
             else
               _buildSelfiePreview(),
             
             const Spacer(),
             
             SizedBox(
               width: double.infinity,
               child: ElevatedButton.icon(
                 onPressed: _selfie == null ? _takeSelfie : _markAttendance,
                 icon: Icon(_selfie == null ? LucideIcons.camera : LucideIcons.check),
                 label: Text(_selfie == null ? "Verify Identity (Selfie)" : "Submit Attendance"),
                 style: ElevatedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 ),
               ),
             ),
             if (_selfie != null)
               TextButton(
                 onPressed: _takeSelfie,
                 child: const Text("Retake Selfie"),
               )
          ],
        ),
      ),
    );
  }

  Widget _buildScanPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(40),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Icon(LucideIcons.qr_code, size: 80, color: Colors.black54),
          const SizedBox(height: 20),
          Text(
            "Scan & Verify",
            style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Take a selfie to verify your identity\nwithin the classroom.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSelfiePreview() {
    return Column(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.green, width: 3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(_selfie!, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.circle_check, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Text("Face Recognized", style: GoogleFonts.outfit(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

