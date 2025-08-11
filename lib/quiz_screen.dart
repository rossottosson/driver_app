// lib/quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'content_data.dart';
import 'progress_provider.dart';
import 'sound_manager.dart';
import 'dart:math'; // NYTT: Importerad för att kunna blanda

class QuizScreen extends StatefulWidget {
  final String quizId;
  const QuizScreen({super.key, required this.quizId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _correctAnswerCount = 0;
  int? _selectedDisplayIndex; // ÄNDRAD: Bytt namn för tydlighet
  bool _answerChecked = false;

  late final List<Map<String, dynamic>> _questionsForThisQuiz;

  // NYTT: State för att hantera blandade svar
  late List<String> _shuffledOptions;
  late List<int> _originalIndices;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    if (_questionsForThisQuiz.isNotEmpty) {
      _loadAndShuffleQuestion();
    }
  }

  void _loadQuestions() {
    final quizContent = quizData[widget.quizId];
    if (quizContent == null) {
      _questionsForThisQuiz = [];
      return;
    }
    
    final questionIds = quizContent['questionIds'] as List<String>;
    
    _questionsForThisQuiz = questionBank
        .where((question) => questionIds.contains(question['id']))
        .toList();
  }

  // NYTT: Funktion för att ladda och blanda en fråga
  void _loadAndShuffleQuestion() {
    final question = _questionsForThisQuiz[_currentQuestionIndex];
    final originalOptions = List<String>.from(question['options'] as List);

    // Skapa en lista med objekt som innehåller text och originalindex
    final indexedOptions = originalOptions
        .asMap()
        .entries
        .map((entry) => {'text': entry.value, 'originalIndex': entry.key})
        .toList();
    
    // Blanda listan
    indexedOptions.shuffle(Random());

    // Uppdatera state med den blandade datan
    setState(() {
      _shuffledOptions = indexedOptions.map((e) => e['text'] as String).toList();
      _originalIndices = indexedOptions.map((e) => e['originalIndex'] as int).toList();
      _selectedDisplayIndex = null;
      _answerChecked = false;
    });
  }

  bool get _isLastQuestion => _currentQuestionIndex == _questionsForThisQuiz.length - 1;

  void _checkAnswer() {
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    final question = _questionsForThisQuiz[_currentQuestionIndex];
    final correctAnswerIndex = question['correctAnswerIndex'] as int;

    // ÄNDRAD: Jämför det ursprungliga indexet, inte displayindexet
    final selectedOriginalIndex = _originalIndices[_selectedDisplayIndex!];

    if (selectedOriginalIndex == correctAnswerIndex) {
      _correctAnswerCount++;
      SoundManager.playCorrectSound(progressProvider.isSoundOn);
    } else {
      SoundManager.playIncorrectSound(progressProvider.isSoundOn); 
    }
    setState(() {
      _answerChecked = true;
    });
  }

  void _nextQuestion() {
    if (_isLastQuestion) {
      _submitQuiz();
    } else {
      setState(() {
        _currentQuestionIndex++;
      });
      _loadAndShuffleQuestion(); // Ladda och blanda nästa fråga
    }
  }

  void _submitQuiz() {
    final score = _questionsForThisQuiz.isNotEmpty ? _correctAnswerCount / _questionsForThisQuiz.length : 0.0;
    
    if (score >= 0.6) {
      Provider.of<ProgressProvider>(context, listen: false)
          .unlockNextStop(widget.quizId);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsScreen(
          score: score,
          quizId: widget.quizId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizInfo = quizData[widget.quizId];
    if (quizInfo == null || _questionsForThisQuiz.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz ${widget.quizId}')),
        body: const Center(child: Text('Quiz not found or has no questions.')),
      );
    }
    
    final question = _questionsForThisQuiz[_currentQuestionIndex];
    // ÄNDRAD: Använder inte längre options direkt från frågan här
    final imagePaths = List<String>.from(question['imagePaths'] as List);

    return Scaffold(
      appBar: AppBar(
        title: Text(quizInfo['title'] as String),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1}/${_questionsForThisQuiz.length}',
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

              // ÄNDRAD: Bygger listan från de blandade alternativen
              ...List.generate(_shuffledOptions.length, (index) {
                Color? tileColor;
                if (_answerChecked) {
                  final correctAnswerIndex = question['correctAnswerIndex'] as int;
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
                    title: Text(_shuffledOptions[index]), // Visar blandat alternativ
                    value: index, // Värdet är displayindex
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
                _buildExplanationCard(question),

              const SizedBox(height: 40),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _selectedDisplayIndex == null ? null : () {
                  if (_answerChecked) {
                    _nextQuestion();
                  } else {
                    _checkAnswer();
                  }
                },
                child: Text(
                  _answerChecked
                      ? (_isLastQuestion ? 'Finish Quiz' : 'Next Question')
                      : 'Check Answer',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildExplanationCard(Map<String, dynamic> question) {
    // ÄNDRAD: Logik för att avgöra om svaret var rätt
    final correctAnswerIndex = question['correctAnswerIndex'] as int;
    final selectedOriginalIndex = _originalIndices[_selectedDisplayIndex!];
    final bool isCorrect = selectedOriginalIndex == correctAnswerIndex;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isCorrect ? Colors.green : Colors.red, width: 2)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCorrect ? 'Correct!' : 'Incorrect',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isCorrect ? Colors.green[800] : Colors.red[800],
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

// Ingen ändring i QuizResultsScreen, så den är exkluderad för korthetens skull
class QuizResultsScreen extends StatelessWidget {
  final double score;
  final String quizId;

  const QuizResultsScreen({
    super.key,
    required this.score,
    required this.quizId,
  });
  
  void _resetQuiz(BuildContext context) {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(quizId: quizId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool passed = score >= 0.6;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Text(
              passed ? 'Congratulations, you passed!' : 'Keep Studying!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: passed ? Colors.green : Colors.orange[800]),
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score: ${(score * 100).toStringAsFixed(0)}%',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
             Text(
              'You needed 60% to pass.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: passed ? Colors.green : Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                if (passed) {
                  Navigator.pop(context);
                } else {
                  _resetQuiz(context);
                }
              },
              child: Text(
                passed ? 'Continue Journey' : 'Try Again',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 12),
            if (!passed)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back to Map'),
              ),
          ],
        ),
      ),
    );
  }
}