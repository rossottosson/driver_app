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
    final Color primaryColor = Colors.blueGrey.shade800;
    final Color backgroundColor = Colors.green.shade100;

    return MaterialApp(
      title: 'Driver\'s License App',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: primaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white
          )
        )
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
  final double roadHeight = 11400.0;
  
  final List<Map<String, dynamic>> roadStops = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized && mounted) {
        _initializeStops();
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  void _initializeStops() {
    final double screenWidth = MediaQuery.of(context).size.width;
    
    final List<Map<String, dynamic>> bubbleData = [
      {'label': 'Start', 'isQuiz': false}, 
      {'label': '1.1', 'isQuiz': false, 'imageAsset': 'assets/images/L1_Sign.png'},
      {'label': '1.2', 'isQuiz': false},
      {'label': 'Q1',  'isQuiz': true},
      {'label': '2.1', 'isQuiz': false, 'imageAsset': 'assets/images/L2_Sign.png'},
      {'label': '2.2', 'isQuiz': false},
      {'label': 'Q2',  'isQuiz': true},
      {'label': '3.1', 'isQuiz': false, 'imageAsset': 'assets/images/L3_Sign.png'},
      {'label': '3.2', 'isQuiz': false},
      {'label': 'Q3',  'isQuiz': true},
      {'label': '4.1', 'isQuiz': false, 'imageAsset': 'assets/images/L4_Sign.png'},
      {'label': '4.2', 'isQuiz': false},
      {'label': 'Q4',  'isQuiz': true},
      {'label': '5.1', 'isQuiz': false, 'imageAsset': 'assets/images/L5_Sign.png'},
      {'label': '5.2', 'isQuiz': false},
      {'label': '5.3', 'isQuiz': false},
      {'label': '5.4', 'isQuiz': false},
      {'label': '5.5', 'isQuiz': false},
      {'label': 'Q5',  'isQuiz': true},
      {'label': '6.1', 'isQuiz': false, 'imageAsset': 'assets/images/L6_Sign.png'},
      {'label': '6.2', 'isQuiz': false},
      {'label': '6.3', 'isQuiz': false},
      {'label': 'Q6',  'isQuiz': true},
      {'label': '7.1', 'isQuiz': false, 'imageAsset': 'assets/images/L7_Sign.png'},
      {'label': '7.2', 'isQuiz': false},
      {'label': 'Q7',  'isQuiz': true},
      {'label': '8.1', 'isQuiz': false, 'imageAsset': 'assets/images/L8_Sign.png'},
      {'label': '8.2', 'isQuiz': false},
      {'label': '8.3', 'isQuiz': false},
      {'label': '8.4', 'isQuiz': false},
      {'label': 'Q8',  'isQuiz': true},
      {'label': '9.1', 'isQuiz': false, 'imageAsset': 'assets/images/L9_Sign.png'},
      {'label': '9.2', 'isQuiz': false},
      {'label': 'Q9',  'isQuiz': true},
      {'label': '10.1','isQuiz': false, 'imageAsset': 'assets/images/L10_Sign.png'},
      {'label': '10.2','isQuiz': false},
      {'label': '10.3','isQuiz': false},
      {'label': 'Q10', 'isQuiz': true},
    ];
    
    final List<Offset> positions = [
      Offset(screenWidth * 0.5, roadHeight - 200),
      Offset(screenWidth * 0.2, roadHeight - 500),
      Offset(screenWidth * 0.8, roadHeight - 800),
      Offset(screenWidth * 0.2, roadHeight - 1100),
      Offset(screenWidth * 0.8, roadHeight - 1400),
      Offset(screenWidth * 0.2, roadHeight - 1700),
      Offset(screenWidth * 0.8, roadHeight - 2000),
      Offset(screenWidth * 0.2, roadHeight - 2300),
      Offset(screenWidth * 0.8, roadHeight - 2600),
      Offset(screenWidth * 0.2, roadHeight - 2900),
      Offset(screenWidth * 0.8, roadHeight - 3200),
      Offset(screenWidth * 0.2, roadHeight - 3500),
      Offset(screenWidth * 0.8, roadHeight - 3800),
      Offset(screenWidth * 0.2, roadHeight - 4100),
      Offset(screenWidth * 0.8, roadHeight - 4400),
      Offset(screenWidth * 0.2, roadHeight - 4700),
      Offset(screenWidth * 0.8, roadHeight - 5000),
      Offset(screenWidth * 0.2, roadHeight - 5300),
      Offset(screenWidth * 0.8, roadHeight - 5600),
      Offset(screenWidth * 0.2, roadHeight - 5900),
      Offset(screenWidth * 0.8, roadHeight - 6200),
      Offset(screenWidth * 0.2, roadHeight - 6500),
      Offset(screenWidth * 0.8, roadHeight - 6800),
      Offset(screenWidth * 0.2, roadHeight - 7100),
      Offset(screenWidth * 0.8, roadHeight - 7400),
      Offset(screenWidth * 0.2, roadHeight - 7700),
      Offset(screenWidth * 0.8, roadHeight - 8000),
      Offset(screenWidth * 0.2, roadHeight - 8300),
      Offset(screenWidth * 0.8, roadHeight - 8600),
      Offset(screenWidth * 0.2, roadHeight - 8900),
      Offset(screenWidth * 0.8, roadHeight - 9200),
      Offset(screenWidth * 0.2, roadHeight - 9500),
      Offset(screenWidth * 0.8, roadHeight - 9800),
      Offset(screenWidth * 0.2, roadHeight - 10100),
      Offset(screenWidth * 0.8, roadHeight - 10400),
      Offset(screenWidth * 0.2, roadHeight - 10700),
      Offset(screenWidth * 0.5, roadHeight - 11000),
      Offset(screenWidth * 0.5, roadHeight - 11300),
    ];
    
    final List<Map<String, dynamic>> stops = [];
    for (int i = 0; i < positions.length; i++) {
        stops.add({
            ...bubbleData[i],
            'pos': positions[i],
        });
    }

    final roadMapLabels = stops.map((stop) => stop['label'] as String).toList();
    Provider.of<ProgressProvider>(context, listen: false).initializeRoadMap(roadMapLabels);

    setState(() {
      roadStops.clear();
      roadStops.addAll(stops);
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
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
    
    if (progressProvider.isLoading || !_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading Journey...'),
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
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
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
              ...roadStops.expand((stop) {
                final List<Widget> widgets = [];
                final position = stop['pos'] as Offset;

                if (stop.containsKey('imageAsset')) {
                  final imageAsset = stop['imageAsset'] as String;
                  
                  // --- MODIFIED: New symmetrical layout logic for signs ---
                  final bool isBubbleOnLeftOrCenter = position.dx <= screenWidth / 2;
                  const double imageSize = 280.0; // A large, visible, but safe size

                  // Determine the center X-coordinate for the sign on the OPPOSITE side of the road
                  final double imageCenterX = isBubbleOnLeftOrCenter
                      ? screenWidth * 0.75 // If bubble is left/center, place sign on the right side
                      : screenWidth * 0.3; // If bubble is on the right, place sign on the left side

                  // Calculate the 'left' property to center the image at its new X-coordinate
                  final double imageLeft = imageCenterX - (imageSize / 2);
                  
                  // Vertically align the image's center with the bubble's center
                  final double imageTop = position.dy - (imageSize / 2);

                  widgets.add(
                    Positioned(
                      top: imageTop,
                      left: imageLeft,
                      child: SizedBox(
                        width: imageSize,
                        height: imageSize,
                        child: Image.asset(imageAsset),
                      ),
                    ),
                  );
                }

                final bool isQuiz = stop['isQuiz'] as bool;
                final String label = stop['label'] as String;
                final bool isLocked = !progressProvider.isUnlocked(label);

                widgets.add(
                  Positioned(
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
                  ),
                );

                return widgets;
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

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
    final Color primaryColor = isQuiz ? Colors.cyan.shade700 : Colors.orange.shade800;
    final Color secondaryColor = isQuiz ? Colors.cyan.shade400 : Colors.orange.shade600;
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
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}