import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Define navigation routes
const String OVERVIEW_ROUTE = '/dashboard';
const String COURSES_ROUTE = '/courses';
const String FILE_MANAGER_ROUTE = '/file_manager';
const String DISCUSSIONS_ROUTE = '/discussions';
const String ASSESSMENTS_ROUTE = '/assessments';
const String ANALYTICS_ROUTE = '/analytics';
const String CALENDAR_ROUTE = '/calendar';

class DashboardScreen extends StatelessWidget {
  final String userType;
  const DashboardScreen({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E13),
      body: Row(
        children: [
          // Sidebar
          Sidebar(userType: userType),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "Welcome back!",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Ready to continue your learning journey?",
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        statCard("Total Courses", "6", Icons.menu_book,
                            "Active enrollments"),
                        statCard("Completed", "2", Icons.emoji_events,
                            "Courses finished"),
                        statCard("Avg Progress", "59%", Icons.show_chart,
                            "Across all courses"),
                        statCard("Learning Hours", "47", Icons.access_time,
                            "This month"),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF12161D),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Recommended Courses",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Icon(Icons.chevron_right, color: Colors.white)
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        CourseCard(
                          title: "Machine Learning",
                          imageUrl:
                              "https://plus.unsplash.com/premium_photo-1682124651258-410b25fa9dc0?w=400&h=200&fit=crop",
                          url:
                              "https://www.cipherschools.com/courses/machine-learning-beginner-friendly-c841",
                        ),
                        SizedBox(width: 16),
                        CourseCard(
                          title: "JavaScript Fundamentals",
                          imageUrl:
                              "https://images.unsplash.com/photo-1724166573009-4634b974ebb2?w=400&h=200&fit=crop",
                          url:
                              "https://www.cipherschools.com/courses/learn-fundamentals-of-javascript-js-8ac9",
                        ),
                        SizedBox(width: 16),
                        CourseCard(
                          title: "Competitive Coding",
                          imageUrl:
                              "https://plus.unsplash.com/premium_photo-1726754457459-d2dfa2e3a434?w=400&h=%20200&fit=crop",
                          url:
                              "https://www.cipherschools.com/courses/competitive-coding-using-c-for-interview-prep-0c5e",
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statCard(String title, String value, IconData icon, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF12161D),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text(value,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey[500]))
          ],
        ),
      ),
    );
  }
}

class Sidebar extends StatefulWidget {
  final String userType;
  const Sidebar({Key? key, required this.userType}) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _sidebarItems = [
    {'icon': Icons.dashboard, 'label': 'Overview', 'route': OVERVIEW_ROUTE},
    {'icon': Icons.book, 'label': 'Courses', 'route': COURSES_ROUTE},
    {
      'icon': Icons.folder,
      'label': 'File Manager',
      'route': FILE_MANAGER_ROUTE
    },
    {'icon': Icons.forum, 'label': 'Discussions', 'route': DISCUSSIONS_ROUTE},
    {
      'icon': Icons.assignment,
      'label': 'Assessments',
      'route': ASSESSMENTS_ROUTE
    },
    {'icon': Icons.bar_chart, 'label': 'Analytics', 'route': ANALYTICS_ROUTE},
    {
      'icon': Icons.calendar_today,
      'label': 'Calendar',
      'route': CALENDAR_ROUTE
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color(0xFF0F1217),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.group, color: Color(0xFF10B981), size: 30),
              SizedBox(width: 12),
              Text(
                "Friends LMS",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ..._sidebarItems.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> item = entry.value;
            return sidebarItem(
              icon: item['icon'],
              label: item['label'],
              route: item['route'],
              isSelected: _selectedIndex == index,
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                Navigator.pushNamed(context, item['route'],
                    arguments: widget.userType);
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget sidebarItem({
    required IconData icon,
    required String label,
    required String route,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
              // Glassmorphism effect
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(isSelected ? 0.15 : 0.05),
                  Colors.white.withOpacity(isSelected ? 0.1 : 0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey[300],
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[300],
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
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

class CourseCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String url;

  const CourseCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url),
                mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
