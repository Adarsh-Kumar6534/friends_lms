import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import all your screens
import 'screens/welcome_screen.dart';
import 'screens/dashboard.dart';
import 'screens/courses_screen.dart';
import 'screens/file_manager_screen.dart';
import 'screens/discussion_screen.dart';
import 'screens/assessments_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/calendar_screen.dart';

// Route constants
const String OVERVIEW_ROUTE = '/dashboard';
const String COURSES_ROUTE = '/courses';
const String FILE_MANAGER_ROUTE = '/file_manager';
const String DISCUSSIONS_ROUTE = '/discussions';
const String ASSESSMENTS_ROUTE = '/assessments';
const String ANALYTICS_ROUTE = '/analytics';
const String CALENDAR_ROUTE = '/calendar';

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
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final args = settings.arguments as String? ?? 'student';

        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());

          case OVERVIEW_ROUTE:
            return MaterialPageRoute(
                builder: (_) => DashboardScreen(userType: args));

          case COURSES_ROUTE:
            return MaterialPageRoute(
                builder: (_) => CoursesScreen(userType: args));

          case FILE_MANAGER_ROUTE:
            return MaterialPageRoute(
                builder: (_) => FileManagerScreen(userType: args));

          case DISCUSSIONS_ROUTE:
            return MaterialPageRoute(
                builder: (_) => DiscussionScreen(userType: args));

          case ASSESSMENTS_ROUTE:
            return MaterialPageRoute(
                builder: (_) => AssessmentsScreen(userType: args));

          case ANALYTICS_ROUTE:
            return MaterialPageRoute(
                builder: (_) => AnalyticsScreen(userType: args));

          case CALENDAR_ROUTE:
            return MaterialPageRoute(
                builder: (_) => CalendarScreen(userType: args));

          default:
            return MaterialPageRoute(
                builder: (_) => const Scaffold(
                      body: Center(child: Text("Page not found")),
                    ));
        }
      },
    );
  }
}
