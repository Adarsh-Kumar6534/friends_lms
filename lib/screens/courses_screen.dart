import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursesScreen extends StatelessWidget {
  final String userType;
  const CoursesScreen({Key? key, required this.userType}) : super(key: key);

  final List<Map<String, String>> courses = const [
    {
      "title": "Machine Learning",
      "image":
          "https://plus.unsplash.com/premium_photo-1682124651258-410b25fa9dc0?w=400&h=200&fit=crop",
      "url":
          "https://www.cipherschools.com/courses/machine-learning-beginner-friendly-c841"
    },
    {
      "title": "JavaScript Fundamentals",
      "image":
          "https://images.unsplash.com/photo-1724166573009-4634b974ebb2?w=400&h=200&fit=crop",
      "url":
          "https://www.cipherschools.com/courses/learn-fundamentals-of-javascript-js-8ac9"
    },
    {
      "title": "Competitive Coding",
      "image":
          "https://plus.unsplash.com/premium_photo-1726754457459-d2dfa2e3a434?w=400&h=%20200&fit=crop",
      "url":
          "https://www.cipherschools.com/courses/competitive-coding-using-c-for-interview-prep-0c5e"
    },
    {
      "title": "Cyber Security",
      "image":
          "https://images.unsplash.com/photo-1614064548237-096f735f344f?w=400&h=200&fit=crop",
      "url":
          "https://www.cipherschools.com/courses/cyber-security-fundamentals-core-concepts-and-practices-75f4"
    },
    {
      "title": "Figma UI/UX",
      "image":
          "https://plus.unsplash.com/premium_photo-1661326248013-3107a4b2bd91?w=400&h=200&fit=crop",
      "url":
          "https://www.cipherschools.com/courses/figma-basic-uiux-in-hindi-d594"
    },
    {
      "title": "Python & Django",
      "image":
          "https://images.unsplash.com/photo-1690683790356-c1edb75e3df7?w=400&h=200&fit=crop",
      "url":
          "https://www.cipherschools.com/courses/python-django-for-beginners-learn-basics-of-python-and-the-backend-framework-django-6620"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E13),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with "Courses" and search bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Courses",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search courses...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: const Color(0xFF12161D),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Grid of course cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2,
                children: courses.map((course) {
                  return _buildCourseCard(
                    context,
                    title: course["title"]!,
                    imageUrl: course["image"]!,
                    url: course["url"]!,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context,
      {required String title, required String imageUrl, required String url}) {
    return InkWell(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
            border: Border.all(
              color: const Color(0xFF10B981).withOpacity(0.5),
              width: 1.5,
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
