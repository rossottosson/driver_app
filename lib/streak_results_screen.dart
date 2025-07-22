// lib/streak_results_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'progress_provider.dart';

class StreakResultsScreen extends StatelessWidget {
  final int finalStreak;

  const StreakResultsScreen({
    super.key,
    required this.finalStreak,
  });

  @override
  Widget build(BuildContext context) {
    // We can access the high score directly from the provider
    final highScore = Provider.of<ProgressProvider>(context, listen: false).streakHighScore;
    final bool isNewHighScore = finalStreak == highScore && finalStreak > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isNewHighScore)
                const Text(
                  'New High Score!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                )
              else
                 const Text(
                  'Nice Try!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Your Streak: $finalStreak',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
               Text(
                'High Score: $highScore',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pop(context); // Go back to the tests screen
                },
                child: const Text('Back to Tests', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}