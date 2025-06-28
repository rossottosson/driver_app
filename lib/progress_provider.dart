// lib/progress_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<String> _roadMap = [];
  final Set<String> _unlockedStops = {};
  Set<String> get unlockedStops => _unlockedStops;

  final List<Map<String, dynamic>> _testHistory = [];
  List<Map<String, dynamic>> get testHistory => _testHistory;
  
  bool _isSoundOn = true;
  bool get isSoundOn => _isSoundOn;
  
  int get testsTaken => _testHistory.length;
  int get testsPassed => _testHistory.where((result) => result['score'] >= 0.8).length;
  double get passageRate => testsTaken > 0 ? testsPassed / testsTaken : 0.0;

  ProgressProvider() {
    _loadProgress();
  }
  
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStops = prefs.getStringList('unlockedStops');
    if (savedStops != null) {
      _unlockedStops.addAll(savedStops);
    }
    
    final savedHistory = prefs.getStringList('testHistory');
    if (savedHistory != null) {
      _testHistory.addAll(savedHistory.map((jsonString) => jsonDecode(jsonString) as Map<String, dynamic>));
    }
    
    // Load sound setting, defaulting to true if not found
    _isSoundOn = prefs.getBool('isSoundOn') ?? true;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('unlockedStops', _unlockedStops.toList());
    final historyAsJson = _testHistory.map((result) => jsonEncode(result)).toList();
    await prefs.setStringList('testHistory', historyAsJson);
  }
  
  void initializeRoadMap(List<String> roadMap) {
    _roadMap = roadMap;
    if (_unlockedStops.isEmpty && _roadMap.isNotEmpty) {
      _unlockedStops.add(_roadMap.first);
    }
    notifyListeners();
  }

  bool isUnlocked(String stopLabel) {
    return _unlockedStops.contains(stopLabel);
  }
  
  Future<void> toggleSound(bool newValue) async {
    _isSoundOn = newValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSoundOn', _isSoundOn);
    notifyListeners();
  }

  void addTestResult({required double score, required int totalQuestions}) {
    _testHistory.add({
      'score': score,
      'totalQuestions': totalQuestions,
      'timestamp': DateTime.now().toIso8601String(),
    });
    _saveProgress();
    notifyListeners();
  }

  void unlockNextStop(String currentStopLabel) {
    final currentIndex = _roadMap.indexOf(currentStopLabel);
    if (currentIndex != -1 && currentIndex + 1 < _roadMap.length) {
      final nextStopLabel = _roadMap[currentIndex + 1];
      if (!_unlockedStops.contains(nextStopLabel)) {
        _unlockedStops.add(nextStopLabel);
        _saveProgress(); 
        notifyListeners();
      }
    }
  }

  Future<void> resetJourneyProgress() async {
    _unlockedStops.clear();
    if (_roadMap.isNotEmpty) {
      _unlockedStops.add(_roadMap.first);
    }
    await _saveProgress();
    notifyListeners();
  }

  Future<void> resetTestHistory() async {
    _testHistory.clear();
    await _saveProgress();
    notifyListeners();
  }
}