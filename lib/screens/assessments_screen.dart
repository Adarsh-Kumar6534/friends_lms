import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'dart:convert';

class AssessmentsScreen extends StatefulWidget {
  final String userType;
  const AssessmentsScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<AssessmentsScreen> createState() => _AssessmentsScreenState();
}

class _AssessmentsScreenState extends State<AssessmentsScreen> {
  int _currentLevel = 1;
  int _currentQuestion = 0;
  int _score = 0;
  bool _quizStarted = false;
  bool _quizCompleted = false;
  String? _feedback;
  Map<int, List<Map<String, dynamic>>> _questions = {};
  final _confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    try {
      final jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/questions.json');
      final json = jsonDecode(jsonString);
      setState(() {
        _questions = {
          1: List<Map<String, dynamic>>.from(json['Computer Science']['1']),
          2: List<Map<String, dynamic>>.from(json['Computer Science']['2']),
          3: List<Map<String, dynamic>>.from(json['Computer Science']['3']),
          4: List<Map<String, dynamic>>.from(json['Computer Science']['4']),
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load questions: $e')),
      );
    }
  }

  Future<bool> _canAccessLevel(int level) async {
    if (level == 1) return true;
    final prefs = await SharedPreferences.getInstance();
    final score = prefs.getInt('score_level_${level - 1}') ?? 0;
    return score >= 8;
  }

  void _startQuiz(int level) async {
    final canAccess = await _canAccessLevel(level);
    if (!canAccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'You need 80% in Level ${level - 1} to unlock this level')),
      );
      return;
    }
    setState(() {
      _currentLevel = level;
      _currentQuestion = 0;
      _score = 0;
      _quizStarted = true;
      _quizCompleted = false;
      _feedback = null;
    });
  }

  void _answerQuestion(String selected) async {
    final correctAnswer =
        _questions[_currentLevel]![_currentQuestion]['answer'];
    setState(() {
      _feedback = selected == correctAnswer ? 'Correct!' : 'Incorrect';
      if (selected == correctAnswer) _score++;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (_currentQuestion < _questions[_currentLevel]!.length - 1) {
      setState(() {
        _currentQuestion++;
        _feedback = null;
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('score_level_$_currentLevel', _score);
      setState(() {
        _quizCompleted = true;
        _quizStarted = false;
        _feedback = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessments', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E13),
              const Color(0xFF1A2A44).withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _quizStarted
                ? _buildQuestionCard()
                : _quizCompleted
                    ? _buildResultCard()
                    : _buildLevelSelector(),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelSelector() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Choose Assessment Level",
            style: TextStyle(
                fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<int>>(
            future: _getLevelScores(),
            builder: (context, snapshot) {
              final scores = snapshot.data ?? [0, 0, 0, 0];
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: scores.where((s) => s >= 8).length / 4,
                    backgroundColor: Colors.grey,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: List.generate(4, (index) {
                      int level = index + 1;
                      return FutureBuilder<bool>(
                        future: _canAccessLevel(level),
                        builder: (context, snapshot) {
                          final isUnlocked = snapshot.data ?? (level == 1);
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              backgroundColor: isUnlocked
                                  ? const Color(0xFF10B981)
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadowColor:
                                  const Color(0xFF10B981).withOpacity(0.5),
                              elevation: 5,
                            ),
                            onPressed:
                                isUnlocked ? () => _startQuiz(level) : null,
                            child: Text(
                              "Level $level",
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<List<int>> _getLevelScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scores = List<int>.filled(4, 0);
    for (int i = 1; i <= 4; i++) {
      scores[i - 1] = prefs.getInt('score_level_$i') ?? 0;
    }
    return scores;
  }

  Widget _buildQuestionCard() {
    if (_questions[_currentLevel]?.isEmpty ?? true) {
      return const Center(child: CircularProgressIndicator());
    }
    final question = _questions[_currentLevel]![_currentQuestion];
    return FadeIn(
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Level $_currentLevel - Question ${_currentQuestion + 1}/10",
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                CircularProgressIndicator(
                  value: (_currentQuestion + 1) / 10,
                  backgroundColor: Colors.grey,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              question['question'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            ...question['options'].map<Widget>((option) {
              return GestureDetector(
                onTap: () => _answerQuestion(option),
                child: ZoomIn(
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF10B981).withOpacity(0.9),
                          const Color(0xFF14B8A6).withOpacity(0.9),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              _feedback != null && option == question['answer']
                                  ? Colors.green.withOpacity(0.5)
                                  : _feedback != null &&
                                          option != question['answer']
                                      ? Colors.red.withOpacity(0.5)
                                      : Colors.transparent,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              );
            }).toList(),
            if (_feedback != null) ...[
              const SizedBox(height: 16),
              Text(
                _feedback!,
                style: TextStyle(
                  color: _feedback == 'Correct!' ? Colors.green : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    if (_score >= 8) _confettiController.play();
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          colors: const [Color(0xFF10B981), Color(0xFF14B8A6), Colors.white],
        ),
        FadeIn(
          duration: const Duration(milliseconds: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Level $_currentLevel Completed!",
                style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Your Score: $_score / 10",
                style: const TextStyle(fontSize: 22, color: Colors.white70),
              ),
              const SizedBox(height: 12),
              if (_score >= 8)
                const Text(
                  "Great job! Next level unlocked!",
                  style: TextStyle(fontSize: 18, color: Color(0xFF10B981)),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => setState(() {
                  _quizCompleted = false;
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14B8A6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  shadowColor: const Color(0xFF14B8A6).withOpacity(0.5),
                  elevation: 5,
                ),
                child: const Text(
                  "Back to Levels",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
