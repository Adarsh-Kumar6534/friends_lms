import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart'; // Ensure this file exists in your project

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedDomain;
  String? selectedYear;
  String? selectedCourse;

  // Lists of options for each question
  final List<String> domains = [
    'Computer Science',
    'Mechanical Engineering',
    'Electrical Engineering',
    'Civil Engineering',
    'Biotechnology',
    'Business Administration',
    'Data Science',
    'Artificial Intelligence',
  ];
  final List<String> years = ['1', '2', '3', '4'];
  final List<String> courses = [
    'B.Tech',
    'M.Tech',
    'BCA',
    'MCA',
    'B.Sc',
    'M.Sc',
    'MBA',
    'BBA',
  ];
  final List<String> masterCourses = ['M.Tech', 'MCA', 'M.Sc', 'MBA'];

  // Get available years based on selected course
  List<String> getAvailableYears() {
    if (selectedCourse == null || !masterCourses.contains(selectedCourse)) {
      return years; // Bachelor's: show all years (1–4)
    }
    return years.take(2).toList(); // Master's: show only years 1–2
  }

  // Logic to determine Senior or Junior
  String determineUserType(String? year, String? course) {
    if (year == null || course == null)
      return 'Junior'; // Default to Junior if incomplete

    // Master's courses are always Senior
    if (masterCourses.contains(course)) {
      return 'Senior';
    }

    // Bachelor's courses: Senior if year >= 75% of 4 years (i.e., Year 3 or 4)
    int yearNum = int.parse(year);
    const int bachelorDuration = 4;
    double progress = yearNum / bachelorDuration;
    return progress >= 0.75 ? 'Senior' : 'Junior';
  }

  void navigateToLogin(BuildContext context) {
    if (selectedDomain != null &&
        selectedYear != null &&
        selectedCourse != null) {
      String userType = determineUserType(selectedYear, selectedCourse);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(userType: userType),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions')),
      );
    }
  }

  void showOptionsModal(BuildContext context, List<String> options,
      String? selectedOption, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map((option) => OptionCard(
                      text: option,
                      isSelected: selectedOption == option,
                      onTap: () {
                        onSelect(option);
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient (same as LoginScreen)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0f172a),
                  Color(0xFF0f1e30),
                  Color(0xFF082f2b),
                  Color(0xFF04201e),
                  Color(0xFF0f172a),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Who are you?',
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Course Question
                    QuestionCard(
                      question: 'What is your course?',
                      selectedOption: selectedCourse ?? 'Select Course',
                      onTap: () => showOptionsModal(
                        context,
                        courses,
                        selectedCourse,
                        (value) => setState(() {
                          selectedCourse = value;
                          // Reset selectedYear if it's invalid for the new course
                          if (selectedYear != null &&
                              masterCourses.contains(value) &&
                              int.parse(selectedYear!) > 2) {
                            selectedYear = null;
                          }
                        }),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Domain Question
                    QuestionCard(
                      question: 'What is your domain?',
                      selectedOption: selectedDomain ?? 'Select Domain',
                      onTap: () => showOptionsModal(
                        context,
                        domains,
                        selectedDomain,
                        (value) => setState(() => selectedDomain = value),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Year Question
                    QuestionCard(
                      question: 'Which year are you in?',
                      selectedOption: selectedYear ?? 'Select Year',
                      onTap: () => showOptionsModal(
                        context,
                        getAvailableYears(),
                        selectedYear,
                        (value) => setState(() => selectedYear = value),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF10b981),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.2)),
                          foregroundColor: Colors.white,
                        ).copyWith(
                          overlayColor: WidgetStateProperty.all(
                              Colors.white.withOpacity(0.1)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10b981).withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        onPressed: () => navigateToLogin(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String question;
  final String selectedOption;
  final VoidCallback onTap;

  const QuestionCard({
    super.key,
    required this.question,
    required this.selectedOption,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: selectedOption.startsWith('Select')
                      ? [
                          Colors.white.withOpacity(0.05),
                          Colors.white.withOpacity(0.05)
                        ]
                      : [const Color(0xFF10B981), const Color(0xFF22C55E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedOption,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white70),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OptionCard extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (value) => setState(() => _isHovered = value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isSelected
                ? [const Color(0xFF10B981), const Color(0xFF22C55E)]
                : [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.05)
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: widget.isSelected
                  ? const Color(0xFF10B981).withOpacity(0.5)
                  : Colors.black.withOpacity(0.4),
              blurRadius: _isHovered ? 24 : 20,
              spreadRadius: _isHovered ? 4 : 2,
              offset: const Offset(0, 4),
            ),
            if (widget.isSelected)
              BoxShadow(
                color: const Color(0xFF22C55E).withOpacity(0.3),
                blurRadius: _isHovered ? 24 : 20,
                spreadRadius: _isHovered ? 4 : 2,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white,
              fontWeight:
                  widget.isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
