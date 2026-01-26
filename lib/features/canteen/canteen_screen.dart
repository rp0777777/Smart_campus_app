import 'package:flutter/material.dart';
import '../../services/mock_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../widgets/upi_payment_screen.dart';

class CanteenScreen extends StatelessWidget {
  const CanteenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Canteen")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Waste Prediction Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.deepOrange.shade400]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     children: [
                       const Icon(LucideIcons.trending_down, color: Colors.white),
                       const SizedBox(width: 8),
                       Text("Food Waste Prediction", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                     ],
                   ),
                   const SizedBox(height: 16),
                   Text("25% Less Waste Expected Today", style: GoogleFonts.outfit(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 8),
                   Text("Based on student attendance and past trends.", style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.9))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text("Today's Menu", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                final items = [
                  {"name": "Veg Thali", "price": "₹80", "cal": "450 kcal"},
                  {"name": "Chicken Biryani", "price": "₹120", "cal": "600 kcal"},
                  {"name": "Paneer Wrap", "price": "₹60", "cal": "300 kcal"},
                ];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(LucideIcons.utensils, color: Colors.orange),
                    ),
                    title: Text(items[index]['name']!, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                    subtitle: Text(items[index]['cal']!),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        final success = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UpiPaymentScreen(
                              itemName: items[index]['name']!,
                              amount: items[index]['price']!,
                            ),
                          ),
                        );
                        
                        if (success == true && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Order Successful: ${items[index]['name']}! View in Admin Panel."),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }, 
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                      child: Text(items[index]['price']!)
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

