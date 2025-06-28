// lib/practice_tests_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'progress_provider.dart';
import 'content_data.dart';
import 'mock_test_screen.dart';

class PracticeTestsScreen extends StatelessWidget {
  const PracticeTestsScreen({super.key});

  // --- THIS FUNCTION IS NOW CORRECTED ---
  // It now correctly uses the central questionBank instead of the old quizData structure.
  List<Map<String, dynamic>> _getAllQuestions() {
    // Create a new list from the question bank so we can shuffle it without affecting the original.
    final allQuestions = List<Map<String, dynamic>>.from(questionBank);
    allQuestions.shuffle();
    return allQuestions;
  }
  
  void _startTest(BuildContext context, int questionCount) {
    final allQuestions = _getAllQuestions();
    if (allQuestions.length < questionCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not enough questions available to start a $questionCount-question test.')),
      );
      return;
    }

    final testQuestions = allQuestions.take(questionCount).toList();
    final duration = Duration(minutes: questionCount);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MockTestScreen(questions: testQuestions, duration: duration),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<int> testOptions = [10, 20, 30, 40, 50];

    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Practice Tests'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.28,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: _buildScoreChart(context, progressProvider.testHistory),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              _buildStatsGrid(progressProvider),
              const SizedBox(height: 24),
              const Divider(thickness: 1),
              const SizedBox(height: 16),
              const Text('Start a New Test', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              Column(
                children: testOptions.map((count) {
                  return _buildTestOptionButton(context, count);
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildTestOptionButton(BuildContext context, int questionCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(double.infinity, 36), 
        ),
        onPressed: () => _startTest(context, questionCount),
        child: Text('$questionCount Questions', style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildStatsGrid(ProgressProvider provider) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Tests Taken', provider.testsTaken.toString()),
          const VerticalDivider(thickness: 1),
          _buildStatItem('Tests Passed', provider.testsPassed.toString()),
          const VerticalDivider(thickness: 1),
          _buildStatItem('Pass Rate', '${(provider.passageRate * 100).toStringAsFixed(0)}%'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildScoreChart(BuildContext context, List<Map<String, dynamic>> history) {
    if (history.length < 2) {
      return const Center(child: Text('Complete at least two tests to see your progress chart.'));
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < history.length; i++) {
      spots.add(FlSpot(i.toDouble(), (history[i]['score'] as double) * 100));
    }

    return LineChart(
      LineChartData(
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 80,
              color: Colors.redAccent.withOpacity(0.8),
              strokeWidth: 3,
              dashArray: [20, 10],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 5, bottom: 2),
                style: TextStyle(color: Colors.white, backgroundColor: Colors.redAccent.withOpacity(0.8), fontWeight: FontWeight.bold),
                labelResolver: (line) => 'Pass: 80%',
              ),
            ),
          ],
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) => const FlLine(color: Color(0x2237434d), strokeWidth: 1),
          getDrawingVerticalLine: (value) => const FlLine(color: Color(0x2237434d), strokeWidth: 1),
        ),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
        minX: 0,
        maxX: (history.length - 1).toDouble(),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: Theme.of(context).primaryColor.withOpacity(0.2)),
            color: Theme.of(context).primaryColor
          ),
        ],
      ),
      duration: const Duration(milliseconds: 250),
    );
  }
}