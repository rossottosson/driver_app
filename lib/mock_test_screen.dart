// lib/mock_test_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'progress_provider.dart';
import 'mock_test_results_screen.dart'; 
import 'dart:math'; // NYTT: Importerad för att kunna blanda

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
  // ÄNDRAD: Selected answers sparar nu det ursprungliga, korrekta indexet
  final Map<int, int> _selectedAnswers = {}; 
  
  Timer? _timer;
  late int _remainingSeconds;

  // NYTT: State för att hantera blandade svar för den aktuella frågan
  late List<String> _shuffledOptions;
  late List<int> _originalIndices;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration.inSeconds;
    _loadAndShuffleQuestion(0); // Ladda och blanda första frågan
    _startTimer();
  }

  // NYTT: Funktion för att ladda och blanda en specifik fråga
  void _loadAndShuffleQuestion(int index) {
    final question = widget.questions[index];
    final originalOptions = List<String>.from(question['options'] as List);

    final indexedOptions = originalOptions
        .asMap()
        .entries
        .map((entry) => {'text': entry.value, 'originalIndex': entry.key})
        .toList();
    
    indexedOptions.shuffle(Random());

    setState(() {
      _currentQuestionIndex = index;
      _shuffledOptions = indexedOptions.map((e) => e['text'] as String).toList();
      _originalIndices = indexedOptions.map((e) => e['originalIndex'] as int).toList();
    });
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
    _selectedAnswers.forEach((questionIndex, selectedAnswerOriginalIndex) {
      if (widget.questions[questionIndex]['correctAnswerIndex'] == selectedAnswerOriginalIndex) {
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
    final isLastQuestion = _currentQuestionIndex == widget.questions.length - 1;
    final imagePaths = List<String>.from(question['imagePaths'] as List);

    // NYTT: Hitta vilket display-index det valda svaret har
    final selectedOriginalIndex = _selectedAnswers[_currentQuestionIndex];
    final displayGroupValue = selectedOriginalIndex == null
        ? null
        : _originalIndices.indexOf(selectedOriginalIndex);

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
                        return RadioListTile<int>(
                          title: Text(_shuffledOptions[index]),
                          value: index,
                          groupValue: displayGroupValue,
                          onChanged: (value) {
                            setState(() {
                              // Spara det ursprungliga indexet i _selectedAnswers
                              final originalIndex = _originalIndices[value!];
                              _selectedAnswers[_currentQuestionIndex] = originalIndex;
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
                      // Ladda och blanda nästa fråga
                      _loadAndShuffleQuestion(_currentQuestionIndex + 1);
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