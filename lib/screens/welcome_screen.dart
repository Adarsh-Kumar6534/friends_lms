import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'role_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _AnimatedBackground(),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
                      ),
                    ),
                    child:
                        const Icon(Icons.group, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 24),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF10B981),
                        Color(0xFF14B8A6),
                        Color(0xFF3B82F6)
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'Welcome to Friends LMS',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your Learning Management System',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Connect, learn, and grow together in our collaborative learning environment. '
                    'Whether you’re here to teach or learn, Friends LMS brings everyone together for an amazing educational experience.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoleSelectionScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Click here to get started',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    // Collaborative (left)
    Column(
      children: const [
        Icon(Icons.groups, color: Color(0xFF10B981), size: 32),
        SizedBox(height: 8),
        Text(
          'Collaborative',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          'Learn together\nwith friends and mentors',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    ),

    // Interactive (center)
    Column(
      children: const [
        Icon(Icons.auto_graph_rounded, color: Color(0xFF10B981), size: 32),
        SizedBox(height: 8),
        Text(
          'Interactive',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          'Engaging courses\nand activities',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    ),

    // Progressive (right)
    Column(
      children: const [
        Icon(Icons.arrow_forward_rounded, color: Color(0xFF3B82F6), size: 32),
        SizedBox(height: 8),
        Text(
          'Progressive',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          'Track your learning\njourney',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    ),
  ],
),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0E13),
            Color(0xFF0F1217),
            Color(0xFF081B1A),
            Color(0xFF081C1B),
            Color(0xFF0A0E13),
          ],
        ),
      ),
    );
  }
}
