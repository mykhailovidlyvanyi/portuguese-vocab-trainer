// lib/screens/mode_selection_screen.dart

import 'package:material_ui/material_ui.dart';

import '../models/word_category.dart';

import 'typing_study_screen.dart';
import 'multiple_choice_study_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  final WordCategory? category;
  final bool isAll;
  final List<WordCategory> allCategories;
  final String studyMethod;

  const ModeSelectionScreen({
    super.key,
    this.category,
    this.isAll = false,
    required this.allCategories,
    this.studyMethod = 'typing',
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
            onTap: () => _openStudyScreen(context, 'enToPt'),
          ),
          ListTile(
            title: const Text('PT → EN'),
            onTap: () => _openStudyScreen(context, 'ptToEn'),
          ),
          ListTile(
            title: const Text('Змішано'),
            onTap: () => _openStudyScreen(context, 'mixed'),
          ),
        ],
      ),
    );
  }

  void _openStudyScreen(BuildContext context, String mode) {
    final screen = studyMethod == 'typing'
        ? TypingStudyScreen(
            category: category,
            isAll: isAll,
            allCategories: allCategories,
            mode: mode,
          )
        : MultipleChoiceStudyScreen(
            category: category,
            isAll: isAll,
            allCategories: allCategories,
            mode: mode,
          );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }
}
