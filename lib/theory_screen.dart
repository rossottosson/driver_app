// lib/theory_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'content_data.dart';
import 'progress_provider.dart';

class TheoryScreen extends StatelessWidget {
  final String chapterKey;

  const TheoryScreen({super.key, required this.chapterKey});

  @override
  Widget build(BuildContext context) {
    final content = theoryData[chapterKey];

    if (content == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Content not found!')),
      );
    }
    
    final String title = content['title'] as String;
    final List<Map<String, String>> contentBlocks = List<Map<String, String>>.from(content['contentBlocks'] as List);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Use a ListView.builder to build the page from the list of blocks
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: contentBlocks.length + 1, // +1 for the continue button at the end
        itemBuilder: (context, index) {

          // If it's the last item in the list, build the Continue button
          if (index == contentBlocks.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                  onPressed: () {
                    Provider.of<ProgressProvider>(context, listen: false)
                        .unlockNextStop(chapterKey);
                    
                    Navigator.pop(context);
                  },
                  child: const Text('Continue', style: TextStyle(fontSize: 18)),
                ),
              ),
            );
          }

          // Otherwise, get the content block for this index
          final block = contentBlocks[index];
          final type = block['type'];
          final data = block['content']!;

          // --- The Block Builder Logic ---
          // It checks the 'type' and returns the correct widget
          switch (type) {
            case 'heading':
              return Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: Text(
                  data,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            case 'paragraph':
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  data,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              );
            case 'image':
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: Image.asset(data)),
              );
            default:
              return const SizedBox.shrink(); // Return an empty widget for unknown types
          }
        },
      ),
    );
  }
}