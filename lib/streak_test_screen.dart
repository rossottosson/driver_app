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
  int? _selectedDisplayIndex; // ÄNDRAD: Bytt namn för tydlighet
  bool _answerChecked = false;
  bool _isCorrect = false;

  // NYTT: State för att hantera blandade svar
  late List<String> _shuffledOptions;
  late List<int> _originalIndices;

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
    
    // Samma blandningslogik som i QuizScreen
    final originalOptions = List<String>.from(question['options'] as List);
    final indexedOptions = originalOptions
        .asMap()
        .entries
        .map((entry) => {'text': entry.value, 'originalIndex': entry.key})
        .toList();
    indexedOptions.shuffle(Random());
    
    setState(() {
      _currentQuestion = question;
      _usedQuestionIds.add(question['id'] as String);
      _shuffledOptions = indexedOptions.map((e) => e['text'] as String).toList();
      _originalIndices = indexedOptions.map((e) => e['originalIndex'] as int).toList();
      _selectedDisplayIndex = null;
      _answerChecked = false;
      _isCorrect = false;
    });
  }

  void _checkAnswer() {
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    final correctAnswerIndex = _currentQuestion['correctAnswerIndex'] as int;
    final selectedOriginalIndex = _originalIndices[_selectedDisplayIndex!];

    setState(() {
      _answerChecked = true;
      if (selectedOriginalIndex == correctAnswerIndex) {
        _isCorrect = true;
        _currentStreak++;
        SoundManager.playCorrectSound(progressProvider.isSoundOn);
      } else {
        _isCorrect = false;
        SoundManager.playIncorrectSound(progressProvider.isSoundOn);
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
                    
                    const SizedBox(height: 16),

                    if (imagePaths.isNotEmpty)
                      Center(
                        child: SizedBox(
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
                    
                    const SizedBox(height: 24),

                    // ÄNDRAD: Bygger från blandade alternativ
                    ...List.generate(_shuffledOptions.length, (index) {
                      Color? tileColor;
                      if (_answerChecked) {
                        final correctAnswerIndex = _currentQuestion['correctAnswerIndex'] as int;
                        final originalIndexOfThisOption = _originalIndices[index];

                        if (originalIndexOfThisOption == correctAnswerIndex) {
                          tileColor = Colors.green.withOpacity(0.3);
                        } else if (index == _selectedDisplayIndex) {
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
                          title: Text(_shuffledOptions[index]),
                          value: index,
                          groupValue: _selectedDisplayIndex,
                          onChanged: _answerChecked ? null : (value) {
                            setState(() {
                              _selectedDisplayIndex = value!;
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
              onPressed: _selectedDisplayIndex == null ? null : () {
                if (_answerChecked) {
                  if (_isCorrect) {
                    _loadNextQuestion();
                  } else {
                    _endGame();
                  }
                } else {
                  _checkAnswer();
                }
              },
              child: Text(
                !_answerChecked
                  ? 'Check Answer'
                  : (_isCorrect ? 'Next Question' : 'Finish'),
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