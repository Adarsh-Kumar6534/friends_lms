import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  final String userType;
  const AnalyticsScreen({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E13),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Learning Analytics",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 24),
              Row(
                children: const [
                  Expanded(child: CourseProgressChart()),
                  SizedBox(width: 16),
                  Expanded(child: TimeSpentChart()),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  StatCard(title: "Total Hours", value: "47"),
                  StatCard(title: "Avg Score", value: "84%"),
                  StatCard(title: "Assignments", value: "12"),
                ],
              ),
              const SizedBox(height: 32),
              const GoalProgressCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF12161D),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 28, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseProgressChart extends StatelessWidget {
  const CourseProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12161D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, _) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('ML',
                          style: TextStyle(color: Colors.white));
                    case 1:
                      return const Text('JS',
                          style: TextStyle(color: Colors.white));
                    case 2:
                      return const Text('CC',
                          style: TextStyle(color: Colors.white));
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
          ),
          barGroups: [
            BarChartGroupData(
                x: 0,
                barRods: [BarChartRodData(toY: 85, color: Colors.greenAccent)]),
            BarChartGroupData(
                x: 1,
                barRods: [BarChartRodData(toY: 65, color: Colors.greenAccent)]),
            BarChartGroupData(
                x: 2,
                barRods: [BarChartRodData(toY: 70, color: Colors.greenAccent)]),
          ],
        ),
      ),
    );
  }
}

class TimeSpentChart extends StatelessWidget {
  const TimeSpentChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12161D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 2),
                FlSpot(1, 3),
                FlSpot(2, 5),
                FlSpot(3, 4),
                FlSpot(4, 7),
                FlSpot(5, 6),
                FlSpot(6, 9),
              ],
              isCurved: true,
              color: Colors.lightGreenAccent,
              barWidth: 3,
              belowBarData:
                  BarAreaData(show: true, color: Colors.green.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalProgressCard extends StatelessWidget {
  const GoalProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF12161D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Monthly Goal",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.6,
            color: Colors.greenAccent,
            backgroundColor: Colors.white12,
            minHeight: 10,
          ),
          const SizedBox(height: 8),
          Text("60% of your monthly goal completed",
              style: TextStyle(color: Colors.grey[400]))
        ],
      ),
    );
  }
}
