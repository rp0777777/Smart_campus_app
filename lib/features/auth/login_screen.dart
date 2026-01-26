import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../screens/dashboard_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAdmin = false;
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1500));
      
      setState(() => _isLoading = false);

      if (_isAdmin) {
        if (_codeController.text == "admin" && _passwordController.text == "admin123") {
          if (mounted) {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (_) => const AdminDashboardScreen())
            );
          }
        } else {
           if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid Admin Credentials (Try: admin / admin123)")),
            );
           }
        }
      } else {
        // Student Login (Mock: Always Success)
        if (mounted) {
           Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (_) => const DashboardScreen())
            );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  LucideIcons.graduation_cap, 
                  size: 80, 
                  color: Theme.of(context).primaryColor
                ),
                const SizedBox(height: 24),
                Text(
                  "Smart Campus", 
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 32, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black87
                  ),
                ),
                Text(
                  "One App for Everything", 
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 16, 
                    color: Colors.grey
                  ),
                ),
                const SizedBox(height: 48),
                
                // Role Toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isAdmin = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isAdmin ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: !_isAdmin ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
                            ),
                            child: Text(
                              "Student",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                color: !_isAdmin ? Colors.black87 : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isAdmin = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isAdmin ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: _isAdmin ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
                            ),
                            child: Text(
                              "Admin",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                color: _isAdmin ? Colors.black87 : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: _isAdmin ? "Admin Username" : "Roll Number",
                    prefixIcon: Icon(_isAdmin ? LucideIcons.shield : LucideIcons.user),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(LucideIcons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                
                const SizedBox(height: 32),
                
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                    : Text(
                        _isAdmin ? "Access Admin Panel" : "Login to Campus",
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                ),
                
                const SizedBox(height: 24),
                if (!_isAdmin)
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "New Student? ",
                        style: GoogleFonts.outfit(color: Colors.grey[600]),
                        children: [
                          TextSpan(
                            text: "Register Here",
                            style: GoogleFonts.outfit(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

