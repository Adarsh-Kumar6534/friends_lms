import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_theme.dart';
import 'glass_container.dart';

class Sidebar extends StatefulWidget {
  final String userType;
  const Sidebar({super.key, required this.userType});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _sidebarItems = [
    {'icon': Icons.dashboard, 'label': 'Overview', 'route': '/dashboard'},
    {'icon': Icons.book, 'label': 'Courses', 'route': '/courses'},
    {'icon': Icons.folder, 'label': 'File Manager', 'route': '/file_manager'},
    {'icon': Icons.forum, 'label': 'Discussions', 'route': '/discussions'},
    {'icon': Icons.assignment, 'label': 'Assessments', 'route': '/assessments'},
    {'icon': Icons.bar_chart, 'label': 'Analytics', 'route': '/analytics'},
    {'icon': Icons.calendar_today, 'label': 'Calendar', 'route': '/calendar'},
  ];

  @override
  Widget build(BuildContext context) {
    // Determine selected index based on current location
    final String location = GoRouterState.of(context).uri.path;
    _selectedIndex = _sidebarItems.indexWhere((item) => item['route'] == location);
    if (_selectedIndex == -1) _selectedIndex = 0;

    return Container(
      width: 240,
      color: const Color(0xFF0F1217),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.group, color: AppTheme.primary, size: 30),
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
            return _buildSidebarItem(
              icon: item['icon'],
              label: item['label'],
              route: item['route'],
              isSelected: _selectedIndex == index,
              onTap: () {
                context.go(item['route'], extra: widget.userType);
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
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
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            borderRadius: 8,
            color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
            border: Border.all(color: Colors.transparent),
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
