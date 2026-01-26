import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../auth/login_screen.dart';

import '../../services/mock_database.dart'; // Ensure path

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final database = MockDatabase();
    final issues = database.getIssues();
    final sosAlerts = database.getSOSAlerts();
    final parkingSlots = database.getParkingSlots();
    final eventRegs = database.getEventRegistrations();
    final classroomBookings = database.getClassroomBookings();
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Admin Intelligence"),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.rotate_ccw),
            onPressed: () => setState((){}),
          ),
          IconButton(
            icon: const Icon(LucideIcons.log_out),
            onPressed: () {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CRITICAL SOS SECTION
            if (sosAlerts.isNotEmpty) ...[
              Text("🚨 CRITICAL ALERTS", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 12),
              ...sosAlerts.map((sos) => Card(
                color: Colors.red[50],
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.red.shade200)),
                child: ListTile(
                  leading: const Icon(LucideIcons.shield_alert, color: Colors.red, size: 30),
                  title: Text(sos['user'], style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                  subtitle: Text("Location: ${sos['location']}\nTime: ${sos['time'].split('T')[1].substring(0, 5)}"),
                  trailing: ElevatedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Emergency Team Dispatched"))),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: const Text("Respond"),
                  ),
                ),
              )),
              const Divider(height: 40),
            ],

            Text("Operational Overview", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard(context, "Students", "2,450", Colors.blue),
                const SizedBox(width: 16),
                _buildStatCard(context, "Issues", "${issues.length}", Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard(context, "Attendance", "${94 + database.getAttendance().length}%", Colors.orange),
                const SizedBox(width: 16),
                _buildStatCard(context, "Events", "${eventRegs.length}", Colors.green),
              ],
            ),
            
            const SizedBox(height: 32),
            _buildSectionHeader(LucideIcons.car, "Parking Management (Live)"),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: parkingSlots.length,
                itemBuilder: (context, index) {
                  final slot = parkingSlots[index];
                  final isAvailable = slot['isAvailable'] as bool;
                  return GestureDetector(
                    onTap: () {
                      database.toggleParkingSlot(slot['id']);
                      setState(() {});
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isAvailable ? Colors.green[50] : Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isAvailable ? Colors.green : Colors.red),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(slot['id'], style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                          Icon(isAvailable ? LucideIcons.lock_keyhole_open : LucideIcons.lock, size: 16),
                          Text(isAvailable ? "Free" : "Busy", style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader(LucideIcons.clipboard_list, "Recent Reports"),
            const SizedBox(height: 12),
            issues.isEmpty 
              ? Center(child: Text("No active issues", style: GoogleFonts.outfit(color: Colors.grey)))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: issues.length,
                  itemBuilder: (context, index) {
                    final item = issues[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red[50],
                          child: const Icon(LucideIcons.triangle_alert, size: 20, color: Colors.red),
                        ),
                        title: Text("${item['category']} Issue", style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                        subtitle: Text("${item['location']} • ${item['status']}\n${item['description']}"),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),

            const SizedBox(height: 32),
            _buildSectionHeader(LucideIcons.building, "Classroom Bookings"),
            const SizedBox(height: 12),
            classroomBookings.isEmpty
              ? Text("No bookings today", style: GoogleFonts.outfit(color: Colors.grey))
              : Column(
                  children: classroomBookings.map((b) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(LucideIcons.users),
                    title: Text("${b['club']} (Room ${b['room']})"),
                    subtitle: Text("Booked by ${b['user']}"),
                  )).toList(),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.outfit(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

