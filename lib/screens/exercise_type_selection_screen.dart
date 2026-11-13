// lib/screens/exercise_type_selection_screen.dart

import 'package:material_ui/material_ui.dart';

import '../models/word_category.dart';
import 'category_selection_screen.dart';

class ExerciseTypeSelectionScreen extends StatelessWidget {
  final List<WordCategory> categories;

  const ExerciseTypeSelectionScreen({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вибір вправи'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('1 з 4'),
            subtitle: const Text(
              'Обери правильний переклад із чотирьох варіантів',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openCategories(context, 'multipleChoice'),
          ),
          ListTile(
            title: const Text('Введення текстом'),
            subtitle: const Text(
              'Самостійно введи переклад слова',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openCategories(context, 'typing'),
          ),
        ],
      ),
    );
  }

  void _openCategories(BuildContext context, String studyMethod) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategorySelectionScreen(
          categories: categories,
          studyMethod: studyMethod,
        ),
      ),
    );
  }
}
