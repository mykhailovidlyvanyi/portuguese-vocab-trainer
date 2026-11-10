// main.dart
import 'package:flutter/material.dart';
import 'screens/category_selection_screen.dart';

void main() {
  runApp(const PortugueseVocabApp());
}

class PortugueseVocabApp extends StatelessWidget {
  const PortugueseVocabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portuguese Vocab Trainer',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const CategorySelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
