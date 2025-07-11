import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart'; // Make sure this file exists in your project

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void navigateToLogin(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(userType: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E13),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Who are you?',
                style: GoogleFonts.inter(
                  fontSize: 36, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                  height: 32), // Increased spacing to move text higher
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => navigateToLogin(context, 'Senior'),
                      child: GlassRoleCard(
                        icon: Icons.school,
                        title: 'Senior',
                        description: 'Mentor or advanced learner',
                        gradientColors: const [
                          Color(0xFF10B981),
                          Color(0xFF22C55E)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => navigateToLogin(context, 'Junior'),
                      child: GlassRoleCard(
                        icon: Icons.menu_book,
                        title: 'Junior',
                        description: 'New or beginner learner',
                        gradientColors: const [
                          Color(0xFF14B8A6),
                          Color(0xFF3B82F6)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassRoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradientColors;

  const GlassRoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: gradientColors[1].withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
