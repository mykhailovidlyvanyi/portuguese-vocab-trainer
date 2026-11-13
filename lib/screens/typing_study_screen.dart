// screens/typing_study_screen.dart

import 'package:material_ui/material_ui.dart';

import '../models/word_category.dart';

import '../utils/study_session.dart';
import '../utils/word_pool_builder.dart';

import '../widgets/session_statistics.dart';

import 'category_selection_screen.dart';

class TypingStudyScreen extends StatefulWidget {
  final WordCategory? category;
  final bool isAll;
  final String mode;
  final List<WordCategory> allCategories;

  const TypingStudyScreen({
    super.key,
    this.category,
    this.isAll = false,
    required this.mode,
    required this.allCategories,
  });

  @override
  State<TypingStudyScreen> createState() => _TypingStudyScreenState();
}

class _TypingStudyScreenState extends State<TypingStudyScreen> {
  late StudySession session;

  String? feedback;

  final controller = TextEditingController();

  bool get isInputEmpty => controller.text.trim().isEmpty;

  @override
  void initState() {
    super.initState();

    final builder = WordPoolBuilder();

    final pool = widget.isAll
        ? builder.fromCategories(widget.allCategories)
        : builder.fromCategory(widget.category!);

    session = StudySession(
      pool: pool,
      mode: widget.mode,
    );

    controller.addListener(() {
      setState(() {});
    });
  }

  void checkAnswer(String answer) {
    final isCorrect = session.checkAnswer(answer);

    setState(() {
      if (isCorrect) {
        feedback = '✅ Правильно!';
      } else {
        feedback =
            '❌ Неправильно. Правильна відповідь: ${session.expectedAnswer}';
      }
    });
  }

  void nextWord() {
    setState(() {
      feedback = null;
      session.nextWord();
      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.isAll ? 'Усе' : widget.category!.name;

    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName — Навчання'),
        actions: [
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => CategorySelectionScreen(
                  categories: widget.allCategories,
                ),
              ),
              (route) => false,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SessionStatistics(
              correct: session.stats.correct,
              total: session.stats.total,
              incorrect: session.stats.incorrect,
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      session.showEnglish
                          ? session.current.english
                          : session.current.portuguese,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (session.showEnglish &&
                        session.current.englishHint != null)
                      Text('Hint: ${session.current.englishHint}'),
                    if (!session.showEnglish &&
                        session.current.portugueseHint != null)
                      Text('Dica: ${session.current.portugueseHint}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (feedback == null) ...[
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Введіть переклад',
                ),
                onSubmitted: isInputEmpty ? null : checkAnswer,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed:
                    isInputEmpty ? null : () => checkAnswer(controller.text),
                child: const Text('Перевірити'),
              ),
              TextButton(
                onPressed: () => checkAnswer(''),
                child: const Text('Я не знаю'),
              ),
            ] else ...[
              Text(feedback!, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: nextWord,
                child: const Text('Продовжити'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
