// screens/subcategory_selection_screen.dart

import 'package:flutter/material.dart';
import '../models/word_category.dart';
import 'mode_selection_screen.dart';

class SubcategorySelectionScreen extends StatelessWidget {
  final WordCategory category;

  const SubcategorySelectionScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListView.builder(
        itemCount: category.subcategories.length,
        itemBuilder: (context, index) {
          final subcategory = category.subcategories[index];

          return ListTile(
            title: Text(subcategory.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ModeSelectionScreen(
                  category: subcategory,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
