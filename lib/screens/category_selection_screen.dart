// screens/category_selection_screen.dart
import 'package:flutter/material.dart';
import '../data/words_data.dart';
import 'mode_selection_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Беремо всі категорії з data/words_data.dart
    final categoriesList = ["Усе", ...categories.map((c) => c.name)];

    return Scaffold(
      appBar: AppBar(title: const Text('Вибір категорії')),
      body: ListView.builder(
        itemCount: categoriesList.length,
        itemBuilder: (context, index) {
          final category = categoriesList[index];
          return ListTile(
            title: Text(category),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ModeSelectionScreen(category: category),
              ),
            ),
          );
        },
      ),
    );
  }
}
