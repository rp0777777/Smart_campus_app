import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/mock_database.dart';

class IssueReporterScreen extends StatefulWidget {
  const IssueReporterScreen({super.key});

  @override
  State<IssueReporterScreen> createState() => _IssueReporterScreenState();
}

class _IssueReporterScreenState extends State<IssueReporterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'Infrastructure';
  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      MockDatabase().addIssue({
        "category": _selectedCategory,
        "location": _locationController.text,
        "description": _descController.text.isEmpty ? "Reported via mobile app" : _descController.text,
        "imagePath": _selectedImage?.path,
        "id": "#${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}"
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Issue Reported Successfully! Sent to Admin Panel."))
      );
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Issue Reporter"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Category"),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Infrastructure', 'Electrical', 'Plumbing', 'Cleanliness', 'Other']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(LucideIcons.tag),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("Location"),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                validator: (v) => v!.isEmpty ? "Required" : null,
                decoration: InputDecoration(
                  hintText: "E.g., Library 2nd Floor",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(LucideIcons.map_pin),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("Description"),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Tell us more about the issue...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(LucideIcons.pen_line),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("Photo Evidence"),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.camera, size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text("Tap to capture photo", style: GoogleFonts.outfit(color: Colors.grey)),
                          ],
                        ),
                ),
              ),
               const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitReport,
                  icon: const Icon(LucideIcons.send),
                  label: const Text("Submit Report"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}

