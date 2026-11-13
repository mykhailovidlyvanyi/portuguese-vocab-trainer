// lib/main.dart

import 'package:material_ui/material_ui.dart';

import 'models/word_category.dart';

import 'screens/exercise_type_selection_screen.dart';
import 'services/vocabulary_service.dart';

void main() {
  runApp(const PortugueseVocabApp());
}

class PortugueseVocabApp extends StatefulWidget {
  const PortugueseVocabApp({super.key});

  @override
  State<PortugueseVocabApp> createState() => _PortugueseVocabAppState();
}

class _PortugueseVocabAppState extends State<PortugueseVocabApp> {
  late final Future<List<WordCategory>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = VocabularyService().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portuguese Vocab Trainer',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<List<WordCategory>>(
        future: categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(
                  'Помилка завантаження слів:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ExerciseTypeSelectionScreen(
            categories: snapshot.data!,
          );
        },
      ),
    );
  }
}
