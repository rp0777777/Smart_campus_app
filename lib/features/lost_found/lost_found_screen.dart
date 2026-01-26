import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/mock_database.dart';

class LostFoundScreen extends StatefulWidget {
  const LostFoundScreen({super.key});

  @override
  State<LostFoundScreen> createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<LostFoundScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _lostItems = [
    {"name": "Keys (Blue Keychain)", "location": "Academic Block", "image": 'assets/images/found_keys.png', "isAsset": true, "date": "1 hour ago"},
    {"name": "iPhone 13 Case", "location": "Canteen Area", "image": null, "isAsset": false, "date": "1 day ago"},
  ];

  final List<Map<String, dynamic>> _foundItems = [
    {"name": "Blue Umbrella", "location": "Library", "image": 'assets/images/found_umbrella.png', "isAsset": true, "date": "2 days ago"},
    {"name": "Water Bottle", "location": "Canteen", "image": 'assets/images/found_bottle.png', "isAsset": true, "date": "3 days ago"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _addItem(bool isFound) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    File? selectedImage;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isFound ? "Report Found Item" : "Report Lost Item", 
                    style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x)),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(LucideIcons.tag),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: isFound ? "Found Location" : "Last Seen Location",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(LucideIcons.map_pin),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setModalState(() {
                      selectedImage = File(image.path);
                    });
                  }
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.camera, size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text("Take photo of item", style: GoogleFonts.outfit(color: Colors.grey)),
                          ],
                        ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && locationController.text.isNotEmpty) {
                      setState(() {
                        final newItem = {
                          "name": nameController.text,
                          "location": locationController.text,
                          "image": selectedImage,
                          "isAsset": false,
                          "date": "Just now",
                        };
                        if (isFound) {
                          _foundItems.insert(0, newItem);
                        } else {
                          _lostItems.insert(0, newItem);
                        }
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isFound ? "Reported Found Item!" : "Reported Lost Item!"))
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Submit Report"),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lost & Found"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.outfit(),
          tabs: const [
            Tab(text: "Lost Items", icon: Icon(LucideIcons.search)),
            Tab(text: "Found Items", icon: Icon(LucideIcons.package)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addItem(_tabController.index == 1),
        label: Text(_tabController.index == 0 ? "Report Lost" : "Report Found"),
        icon: const Icon(LucideIcons.plus),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildItemList(_lostItems, false),
          _buildItemList(_foundItems, true),
        ],
      ),
    );
  }

  Widget _buildItemList(List<Map<String, dynamic>> items, bool isFound) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.info, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text("No items reported yet", style: GoogleFonts.outfit(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150, width: double.infinity, color: Colors.grey[200],
                child: item['image'] != null
                    ? (item['isAsset'] == true 
                        ? Image.asset(item['image'] as String, fit: BoxFit.cover)
                        : Image.file(item['image'] as File, fit: BoxFit.cover))
                    : const Center(child: Icon(LucideIcons.image, size: 40, color: Colors.grey)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      "${isFound ? 'Found at' : 'Last seen at'}: ${item['location']}", 
                      style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 14)
                    ),
                    const SizedBox(height: 4),
                    Text(item['date'], style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text(isFound ? "Contacting Finder..." : "Notifying Owner..."))
                           );
                        },
                        icon: Icon(isFound ? LucideIcons.hand : LucideIcons.message_circle),
                        label: Text(isFound ? "This is Mine!" : "I Found This!"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade50,
                          foregroundColor: Colors.teal,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

