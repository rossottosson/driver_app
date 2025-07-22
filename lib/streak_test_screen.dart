// lib/streak_test_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'content_data.dart';
import 'progress_provider.dart';
import 'sound_manager.dart';
import 'streak_results_screen.dart';

class StreakTestScreen extends StatefulWidget {
  const StreakTestScreen({super.key});

  @override
  State<StreakTestScreen> createState() => _StreakTestScreenState();
}

class _StreakTestScreenState extends State<StreakTestScreen> {
  late Map<String, dynamic> _currentQuestion;
  final List<String> _usedQuestionIds = [];
  int _currentStreak = 0;
  int? _selectedOptionIndex;
  bool _answerChecked = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _loadNextQuestion();
  }

  void _loadNextQuestion() {
    final availableQuestions = questionBank
        .where((q) => !_usedQuestionIds.contains(q['id']))
        .toList();

    if (availableQuestions.isEmpty) {
      _endGame(showRanOutOfQuestions: true);
      return;
    }

    final question = availableQuestions[Random().nextInt(availableQuestions.length)];
    
    setState(() {
      _currentQuestion = question;
      _usedQuestionIds.add(question['id'] as String);
      _selectedOptionIndex = null;
      _answerChecked = false;
      _isCorrect = false;
    });
  }

  void _checkAnswer() {
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    final correctAnswerIndex = _currentQuestion['correctAnswerIndex'] as int;

    setState(() {
      _answerChecked = true;
      if (_selectedOptionIndex == correctAnswerIndex) {
        _isCorrect = true;
        _currentStreak++;
        SoundManager.playCorrectSound(progressProvider.isSoundOn);
      } else {
        _isCorrect = false;
        SoundManager.playIncorrectSound(progressProvider.isSoundOn);
        _endGame();
      }
    });
  }

  void _endGame({bool showRanOutOfQuestions = false}) {
    final provider = Provider.of<ProgressProvider>(context, listen: false);
    provider.updateStreakHighScore(_currentStreak);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StreakResultsScreen(finalStreak: _currentStreak),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_usedQuestionIds.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Streak Mode')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    final options = List<String>.from(_currentQuestion['options'] as List);
    final imagePaths = List<String>.from(_currentQuestion['imagePaths'] as List);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Streak Mode'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.whatshot, color: Colors.orange.shade300),
                  const SizedBox(width: 4),
                  Text(
                    '$_currentStreak',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      _currentQuestion['question'] as String,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
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

                    ...List.generate(options.length, (index) {
                      Color? tileColor;
                      if (_answerChecked) {
                        final correctAnswerIndex = _currentQuestion['correctAnswerIndex'] as int;
                        if (index == correctAnswerIndex) {
                          tileColor = Colors.green.withOpacity(0.3);
                        } else if (index == _selectedOptionIndex) {
                          tileColor = Colors.red.withOpacity(0.3);
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          color: tileColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: tileColor != null ? Colors.transparent : Colors.grey.withOpacity(0.3)
                          )
                        ),
                        child: RadioListTile<int>(
                          title: Text(options[index]),
                          value: index,
                          groupValue: _selectedOptionIndex,
                          onChanged: _answerChecked ? null : (value) {
                            setState(() {
                              _selectedOptionIndex = value!;
                            });
                          },
                        ),
                      );
                    }),
                    
                    if (_answerChecked)
                      _buildExplanationCard(_currentQuestion),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: _selectedOptionIndex == null ? null : () {
                if (_answerChecked) {
                  _loadNextQuestion();
                } else {
                  _checkAnswer();
                }
              },
              child: Text(
                _answerChecked && _isCorrect ? 'Next Question' : 'Check Answer',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard(Map<String, dynamic> question) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _isCorrect ? Colors.green : Colors.red, width: 2)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isCorrect ? 'Correct!' : 'Incorrect',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: _isCorrect ? Colors.green[800] : Colors.red[800],
            ),
          ),
          const Divider(),
          Text(
            question['explanation'] as String,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}