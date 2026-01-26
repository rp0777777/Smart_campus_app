import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/feature_card.dart';
import 'placeholder_screen.dart';
import '../features/issue_reporter/issue_reporter_screen.dart';
import '../features/attendance/attendance_screen.dart';
import '../widgets/gemini_chat_widget.dart';
import '../features/canteen/canteen_screen.dart';
import '../features/mental_health/mental_health_screen.dart';
import '../features/parking/parking_screen.dart';
import '../features/safety/safety_screen.dart';
import '../features/lost_found/lost_found_screen.dart';
import '../features/hostel/hostel_screen.dart';
import '../features/navigation/navigation_screen.dart';
import '../features/study_planner/study_planner_screen.dart';
import '../features/water_monitor/water_monitor_screen.dart';
import '../features/volunteer/volunteer_screen.dart';
import '../features/exam_stress/exam_stress_screen.dart';
import '../features/bus_tracking/bus_tracking_screen.dart';
import '../features/resume/resume_screen.dart';
import '../features/energy/energy_screen.dart';
import '../features/classroom/classroom_screen.dart';
import '../features/translation/translation_screen.dart';
import '../features/waste_segregation/waste_segregation_screen.dart';
import '../features/event_manager/event_manager_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], 
      appBar: AppBar(
        title: Column(
          children: [
            Text("Smart Campus", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            Text("Welcome back, Student", style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey[600])),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(LucideIcons.bell)),
          const SizedBox(width: 8),
          const CircleAvatar(
            backgroundColor: Color(0xFF6C63FF),
            child: Icon(LucideIcons.user, color: Colors.white),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MasonryGridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemCount: _features.length,
          itemBuilder: (context, index) {
             final feature = _features[index];
             return FeatureCard(
               title: feature.title,
               icon: feature.icon,
               color: feature.color,
               onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => feature.destination ?? PlaceholderScreen(title: feature.title),
                   ),
                 );
               },
             );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const GeminiChatWidget(),
          );
        },
        backgroundColor: Colors.white,
        icon: const Icon(LucideIcons.sparkles, color: Colors.blue),
        label: Text("Ask Gemini", style: GoogleFonts.outfit(color: Colors.black87, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class FeatureItem {
  final String title;
  final IconData icon;
  final Color color;
  final Widget? destination;

  FeatureItem(this.title, this.icon, this.color, {this.destination});
}

// List of all 20 Features with assigned colors and icons
final List<FeatureItem> _features = [
  FeatureItem("Issue Reporter", LucideIcons.triangle_alert, Colors.redAccent, destination: const IssueReporterScreen()),
  FeatureItem("AI Attendance", LucideIcons.scan_line, Colors.blueAccent, destination: const AttendanceScreen()),
  FeatureItem("Canteen Waste", LucideIcons.utensils, Colors.orange, destination: const CanteenScreen()),
  FeatureItem("Mental Health", LucideIcons.heart_handshake, Colors.pink, destination: const MentalHealthScreen()),
  FeatureItem("Parking Finder", LucideIcons.car, Colors.indigo, destination: const ParkingScreen()),
  FeatureItem("Safety & SOS", LucideIcons.shield_alert, Colors.red, destination: const SafetyScreen()),
  FeatureItem("Lost & Found", LucideIcons.search, Colors.teal, destination: const LostFoundScreen()),
  FeatureItem("Hostel Complaints", LucideIcons.house, Colors.brown, destination: const HostelScreen()),
  FeatureItem("Campus Nav", LucideIcons.map, Colors.lightGreen, destination: const NavigationScreen()),
  FeatureItem("Study Planner", LucideIcons.book_open, Colors.deepPurple, destination: const StudyPlannerScreen()),
  FeatureItem("Water Monitor", LucideIcons.droplets, Colors.cyan, destination: const WaterMonitorScreen()),
  FeatureItem("Volunteer Match", LucideIcons.users, Colors.amber, destination: const VolunteerScreen()),
  FeatureItem("Exam Stress", LucideIcons.brain_circuit, Colors.deepOrange, destination: const ExamStressScreen()),
  FeatureItem("Bus Tracking", LucideIcons.bus, Colors.blueGrey, destination: const BusTrackingScreen()),
  FeatureItem("Resume Analyzer", LucideIcons.file_text, Colors.purple, destination: const ResumeScreen()),
  FeatureItem("Energy Opt.", LucideIcons.zap, Colors.yellow[800]!, destination: const EnergyScreen()),
  FeatureItem("Classroom Tracker", LucideIcons.layers, Colors.lime, destination: const ClassroomScreen()),
  FeatureItem("Translation", LucideIcons.languages, Colors.lightBlue, destination: const TranslationScreen()),
  FeatureItem("Waste Segregation", LucideIcons.trash_2, Colors.green, destination: const WasteSegregationScreen()),
  FeatureItem("Event Manager", LucideIcons.calendar, Colors.pinkAccent, destination: const EventManagerScreen()),
];

