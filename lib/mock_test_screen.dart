// lib/mock_test_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'progress_provider.dart';
import 'mock_test_results_screen.dart'; 

class MockTestScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final Duration duration;

  const MockTestScreen({
    super.key,
    required this.questions,
    required this.duration,
  });

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  
  Timer? _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration.inSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _submitQuiz();
      }
    });
  }
  
  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _submitQuiz() {
    _timer?.cancel();
    int correctAnswers = 0;
    _selectedAnswers.forEach((questionIndex, selectedAnswerIndex) {
      if (widget.questions[questionIndex]['correctAnswerIndex'] == selectedAnswerIndex) {
        correctAnswers++;
      }
    });
    final score = widget.questions.isNotEmpty ? correctAnswers / widget.questions.length : 0.0;

    Provider.of<ProgressProvider>(context, listen: false).addTestResult(
      score: score,
      totalQuestions: widget.questions.length,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MockTestResultsScreen(
          score: score,
          questions: widget.questions,
          selectedAnswers: _selectedAnswers,
        ),
      ),
    );
  }
  
  Future<bool> _onWillPop() async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Test?'),
          content: const Text('Are you sure you want to leave? Your progress in this test will not be saved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Leave', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestionIndex];
    final options = List<String>.from(question['options'] as List);
    final isLastQuestion = _currentQuestionIndex == widget.questions.length - 1;
    final imagePaths = List<String>.from(question['imagePaths'] as List);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Practice Test'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  _formatDuration(_remainingSeconds),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              LinearProgressIndicator(value: (_currentQuestionIndex + 1) / widget.questions.length),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1}/${widget.questions.length}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        question['question'] as String,
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
                        return RadioListTile<int>(
                          title: Text(options[index]),
                          value: index,
                          groupValue: _selectedAnswers[_currentQuestionIndex],
                          onChanged: (value) {
                            setState(() {
                              _selectedAnswers[_currentQuestionIndex] = value!;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: _selectedAnswers[_currentQuestionIndex] == null ? null : () {
                    if (isLastQuestion) {
                      _submitQuiz();
                    } else {
                      setState(() {
                        _currentQuestionIndex++;
                      });
                    }
                  },
                  child: Text(isLastQuestion ? 'Submit Test' : 'Next Question', style: const TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}