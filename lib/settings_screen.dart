// lib/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'progress_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            children: [
              SwitchListTile(
                title: const Text('Sound Effects'),
                secondary: const Icon(Icons.volume_up),
                value: progressProvider.isSoundOn,
                onChanged: (bool value) {
                  progressProvider.toggleSound(value);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text('Reset Journey Progress'),
                subtitle: const Text('This will re-lock all chapters and quizzes.'),
                onTap: () {
                  _showConfirmationDialog(
                    context: context,
                    title: 'Reset Journey Progress?',
                    content: 'Are you sure? All your road progress will be lost.',
                    onConfirm: () {
                      progressProvider.resetJourneyProgress();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Journey progress has been reset.'), backgroundColor: Colors.green),
                      );
                    },
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete_sweep),
                title: const Text('Reset Test History'),
                subtitle: const Text('This will clear your score graph and statistics.'),
                onTap: () {
                   _showConfirmationDialog(
                    context: context,
                    title: 'Reset Test History?',
                    content: 'Are you sure? Your score chart and stats will be permanently deleted.',
                    onConfirm: () {
                      progressProvider.resetTestHistory();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Test history has been reset.'), backgroundColor: Colors.green),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset', style: TextStyle(color: Colors.red)),
              onPressed: onConfirm,
            ),
          ],
        );
      },
    );
  }
}