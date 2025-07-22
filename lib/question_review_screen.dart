// lib/question_review_screen.dart

import 'package:flutter/material.dart';

class QuestionReviewScreen extends StatelessWidget {
  final Map<String, dynamic> question;
  final int? userAnswerIndex;

  const QuestionReviewScreen({
    super.key,
    required this.question,
    required this.userAnswerIndex,
  });

  @override
  Widget build(BuildContext context) {
    final options = List<String>.from(question['options'] as List);
    final correctAnswerIndex = question['correctAnswerIndex'] as int;
    final imagePaths = List<String>.from(question['imagePaths'] as List);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Review'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'] as String,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            // --- UPDATED: Reduced top spacing ---
            const SizedBox(height: 16),

            if (imagePaths.isNotEmpty)
              Center(
                child: SizedBox(
                  // --- UPDATED: Image height increased to 240 ---
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(imagePaths[index], height: 240),
                      );
                    },
                  ),
                ),
              ),
              
            // --- UPDATED: Reduced bottom spacing ---
            const SizedBox(height: 24),
            const Text('Options:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            
            ...List.generate(options.length, (index) {
              final bool isCorrect = index == correctAnswerIndex;
              final bool isUserChoice = index == userAnswerIndex;
              
              IconData icon;
              Color color;

              if (isCorrect) {
                icon = Icons.check_circle;
                color = Colors.green;
              } else if (isUserChoice) {
                icon = Icons.cancel;
                color = Colors.red;
              } else {
                icon = Icons.radio_button_unchecked;
                color = Colors.grey;
              }

              return Card(
                elevation: 0,
                color: isCorrect ? Colors.green.withOpacity(0.1) : (isUserChoice ? Colors.red.withOpacity(0.1) : null),
                child: ListTile(
                  leading: Icon(icon, color: color),
                  title: Text(options[index]),
                ),
              );
            }),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Explanation:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              question['explanation'] as String,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}