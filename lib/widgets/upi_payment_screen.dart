import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../services/mock_database.dart';

class UpiPaymentScreen extends StatefulWidget {
  final String itemName;
  final String amount;

  const UpiPaymentScreen({super.key, required this.itemName, required this.amount});

  @override
  State<UpiPaymentScreen> createState() => _UpiPaymentScreenState();
}

class _UpiPaymentScreenState extends State<UpiPaymentScreen> {
  bool _isProcessing = true;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _startPaymentSimulation();
  }

  void _startPaymentSimulation() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });
      MockDatabase().placeOrder(widget.itemName, widget.amount);
      
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isSuccess ? Colors.blue.shade700 : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isProcessing) ...[
              const CircularProgressIndicator(color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                "Processing Payment of ${widget.amount}...",
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Do not close or go back", style: GoogleFonts.outfit(color: Colors.grey)),
            ] else if (_isSuccess) ...[
              const Icon(LucideIcons.circle_check, size: 100, color: Colors.white),
              const SizedBox(height: 24),
              Text(
                "Payment Successful!",
                style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Order placed for ${widget.itemName}",
                style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.9)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

