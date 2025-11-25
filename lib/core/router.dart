import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard.dart';
import '../screens/courses_screen.dart';
import '../screens/file_manager_screen.dart';
import '../screens/discussion_screen.dart';
import '../screens/assessments_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/calendar_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        final userType = state.extra as String? ?? 'student';
        return LoginScreen(userType: userType);
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) {
        final userType = state.extra as String? ?? 'student';
        return DashboardScreen(userType: userType);
      },
    ),
    GoRoute(
      path: '/courses',
      builder: (context, state) {
        final userType = state.extra as String? ?? 'student';
        return CoursesScreen(userType: userType);
      },
    ),
    GoRoute(
      path: '/file_manager',
      builder: (context, state) {
        final userType = state.extra as String? ?? 'student';
        return FileManagerScreen(userType: userType);
      },
    ),
    GoRoute(
      path: '/discussions',
      builder: (context, state) {
        final userType = state.extra as String? ?? 'student';
        return DiscussionScreen(userType: userType);
      },
    ),
    GoRoute(
      path: '/assessments',
      builder: (context, state) {
        final userType = state.extra as String? ?? 'student';
        return AssessmentsScreen(userType: userType);
      },
    ),
    GoRoute(
      path: '/analytics',
      builder: (context, state) {
        final userType = state.extra as String? ?? 'student';
        return AnalyticsScreen(userType: userType);
      },
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) {
        final userType = state.extra as String? ?? 'student';
        return CalendarScreen(userType: userType);
      },
    ),
  ],
);
