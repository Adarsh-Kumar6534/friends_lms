import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const FriendsLMSApp());
}

class FriendsLMSApp extends StatelessWidget {
  const FriendsLMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Friends LMS',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E13),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
