// lib/mock_test_results_screen.dart

import 'package:flutter/material.dart';
import 'question_review_screen.dart'; // Import the new review screen

class MockTestResultsScreen extends StatelessWidget {
  final double score;
  final List<Map<String, dynamic>> questions;
  final Map<int, int> selectedAnswers;

  const MockTestResultsScreen({
    super.key,
    required this.score,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final bool passed = score >= 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results'),
        automaticallyImplyLeading: false, // User must use the button at the bottom
      ),
      body: Column(
        children: [
          // --- Top Section: Score Summary ---
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            color: passed ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            child: Column(
              children: [
                Text(
                  passed ? 'Congratulations, you passed!' : 'Keep Studying!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: passed ? Colors.green[800] : Colors.red[800]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your Score: ${(score * 100).toStringAsFixed(0)}%',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Review your answers below:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),

          // --- Middle Section: List of Questions ---
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final selectedAnswer = selectedAnswers[index];
                final bool wasCorrect = selectedAnswer == question['correctAnswerIndex'];

                return ListTile(
                  leading: Icon(
                    wasCorrect ? Icons.check_circle : Icons.cancel,
                    color: wasCorrect ? Colors.green : Colors.red,
                  ),
                  title: Text('Question ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(question['question'] as String, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    // Navigate to the detail screen for this question
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionReviewScreen(
                          question: question,
                          userAnswerIndex: selectedAnswer,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // --- Bottom Section: Back Button ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Pop back to the Practice Tests screen
                  Navigator.pop(context);
                },
                child: const Text('Back to Tests', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}