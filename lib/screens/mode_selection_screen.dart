// screens/mode_selection_screen.dart
import 'package:flutter/material.dart';
import 'study_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  final String category;
  const ModeSelectionScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Режим (${category})')),
      body: Column(
        children: [
          ListTile(
            title: const Text('EN → PT'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudyScreen(category: category, mode: 'enToPt'),
              ),
            ),
          ),
          ListTile(
            title: const Text('PT → EN'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudyScreen(category: category, mode: 'ptToEn'),
              ),
            ),
          ),
          ListTile(
            title: const Text('Змішано'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudyScreen(category: category, mode: 'mixed'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
