// screens/mode_selection_screen.dart

import 'package:flutter/material.dart';
import '../models/word_category.dart';
import 'study_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  final WordCategory? category;
  final bool isAll;

  const ModeSelectionScreen({
    super.key,
    this.category,
    this.isAll = false,
  });

  @override
  Widget build(BuildContext context) {
    final categoryName = isAll ? 'Усе' : category!.name;

    return Scaffold(
      appBar: AppBar(title: Text('Режим ($categoryName)')),
      body: Column(
        children: [
          ListTile(
            title: const Text('EN → PT'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudyScreen(
                  category: category,
                  isAll: isAll,
                  mode: 'enToPt',
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('PT → EN'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudyScreen(
                  category: category,
                  isAll: isAll,
                  mode: 'ptToEn',
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Змішано'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudyScreen(
                  category: category,
                  isAll: isAll,
                  mode: 'mixed',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
