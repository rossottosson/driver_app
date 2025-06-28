// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'road_painter.dart';
import 'theory_screen.dart';
import 'quiz_screen.dart';
import 'progress_provider.dart';
import 'content_data.dart';
import 'practice_tests_screen.dart';
import 'settings_screen.dart';
import 'sound_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProgressProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- NEW Green Theme Color Palette ---
    const Color primaryAppColor = Color(0xFF1B5E20); // A deep, forest green
    const Color lightGreenBackground = Color(0xFFE8F5E9); // A very light, soft green

    return MaterialApp(
      title: 'Driver\'s License App',
      theme: ThemeData(
        primaryColor: primaryAppColor,
        // Using your idea for a green background, but a lighter shade for readability
        scaffoldBackgroundColor: lightGreenBackground,
        
        // Theme for all AppBars
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryAppColor,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),

        // Theme for the BottomNavigationBar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: primaryAppColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
        ),
        
        // Theme for all ElevatedButtons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryAppColor,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; 
  
  static const List<Widget> _pages = <Widget>[
    RoadMapScreen(),
    PracticeTestsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Journey',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'Tests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class RoadMapScreen extends StatefulWidget {
  const RoadMapScreen({super.key});

  @override
  State<RoadMapScreen> createState() => _RoadMapScreenState();
}

class _RoadMapScreenState extends State<RoadMapScreen> {
  late ScrollController _scrollController;
  final double roadHeight = 2000.0;
  final List<Map<String, dynamic>> roadStops = [];
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeStops();
      _isInitialized = true;
    }
  }

  void _initializeStops() {
    final double screenWidth = MediaQuery.of(context).size.width;
    
    final List<Map<String, dynamic>> stops = [
      {'label': '1', 'isQuiz': false, 'pos': Offset(screenWidth * 0.2, roadHeight - 100)},
      {'label': 'Q1', 'isQuiz': true, 'pos': Offset(screenWidth * 0.8, roadHeight - 350)},
      {'label': '2', 'isQuiz': false, 'pos': Offset(screenWidth * 0.2, roadHeight - 600)},
      {'label': 'Q2', 'isQuiz': true, 'pos': Offset(screenWidth * 0.8, roadHeight - 850)},
      {'label': '3', 'isQuiz': false, 'pos': Offset(screenWidth * 0.2, roadHeight - 1100)},
      {'label': 'Q3', 'isQuiz': true, 'pos': Offset(screenWidth * 0.8, roadHeight - 1350)},
      {'label': 'End', 'isQuiz': false, 'pos': Offset(screenWidth * 0.5, roadHeight - 1600)},
    ];

    final roadMapLabels = stops.map((stop) => stop['label'] as String).toList();
    Provider.of<ProgressProvider>(context, listen: false).initializeRoadMap(roadMapLabels);

    setState(() {
      roadStops.addAll(stops);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
       if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final progressProvider = context.watch<ProgressProvider>();
    
    if (progressProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final totalStops = roadStops.length;
    final completedStops = progressProvider.unlockedStops.length;
    final double progressPercent = totalStops > 1 ? ((completedStops - 1) / (totalStops - 1)) : 0.0;
    final int percentage = (progressPercent * 100).toInt();
    final List<Offset> pathPoints = roadStops.map((stop) => stop['pos'] as Offset).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Learning Journey'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(22.0),
          child: Stack(
            children: [
              LinearProgressIndicator(
                value: progressPercent,
                backgroundColor: Colors.grey[700],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange), // An orange progress bar looks good with green
                minHeight: 22.0,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    shadows: [
                      Shadow(blurRadius: 2.0, color: Colors.black54)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: Stack(
            children: [
              CustomPaint(
                painter: RoadPainter(points: pathPoints),
                size: Size(screenWidth, roadHeight),
              ),
              ...roadStops.map((stop) {
                final position = stop['pos'] as Offset;
                final bool isQuiz = stop['isQuiz'] as bool;
                final String label = stop['label'] as String;
                final bool isLocked = !progressProvider.isUnlocked(label);

                return Positioned(
                  top: position.dy - 40,
                  left: position.dx - 40,
                  child: InteractiveBubble(
                    label: label,
                    isQuiz: isQuiz,
                    isLocked: isLocked,
                    onTap: () {
                      final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
                      SoundManager.playBubbleTapSound(progressProvider.isSoundOn);
                      
                      if (isLocked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Complete the previous stop to unlock!'), duration: Duration(seconds: 1)),
                        );
                        return;
                      }

                      if (isQuiz) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(quizId: label),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TheoryScreen(chapterKey: label),
                          ),
                        );
                      }
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Bubble Widget
class InteractiveBubble extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isQuiz;
  final bool isLocked;
  final double radius;

  const InteractiveBubble({
    super.key,
    required this.label,
    required this.onTap,
    this.isQuiz = false,
    this.isLocked = false,
    this.radius = 40,
  });

  @override
  Widget build(BuildContext context) {
    // --- NEW: Bubble colors to match the green theme ---
    final Color primaryColor = isQuiz ? Colors.teal.shade700 : Colors.orange.shade800;
    final Color secondaryColor = isQuiz ? Colors.teal.shade400 : Colors.orange.shade600;
    final Color lockedColor = Colors.grey.shade600;
    final Color lockedSecondaryColor = Colors.grey.shade500;

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: isLocked ? lockedColor : primaryColor,
        child: CircleAvatar(
          radius: radius - 4,
          backgroundColor: isLocked ? lockedSecondaryColor : secondaryColor,
          child: isLocked
              ? Icon(Icons.lock, color: Colors.grey.shade800, size: 40)
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white, // White text for better contrast
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}