// lib/screens/multiple_choice_mode_selection_screen.dart

import 'package:material_ui/material_ui.dart';

import '../models/word_category.dart';

import 'mode_selection_screen.dart';

class MultipleChoiceModeSelectionScreen extends StatelessWidget {
  final WordCategory category;
  final List<WordCategory> allCategories;

  const MultipleChoiceModeSelectionScreen({
    super.key,
    required this.category,
    required this.allCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1 з 4'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Переклад'),
            subtitle: const Text(
              'Обери правильний переклад із чотирьох варіантів',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openLanguageSelection(context, 'translation'),
          ),
          ListTile(
            title: const Text('Відмінювання неправильних дієслів'),
            subtitle: const Text(
              'Обери правильну форму дієслова',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openLanguageSelection(context, 'conjugation'),
          ),
        ],
      ),
    );
  }

  void _openLanguageSelection(BuildContext context, String exerciseMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ModeSelectionScreen(
          category: category,
          allCategories: allCategories,
          studyMethod: 'multipleChoice',
          exerciseMode: exerciseMode,
        ),
      ),
    );
  }
}
