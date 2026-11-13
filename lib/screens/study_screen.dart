// screens/study_screen.dart

import 'package:material_ui/material_ui.dart';
import 'dart:math';

import '../models/word_entry.dart';
import '../models/word_category.dart';

import '../utils/word_selector.dart';
import '../utils/session_stats.dart';

import '../widgets/session_statistics.dart';

import 'category_selection_screen.dart';

class StudyScreen extends StatefulWidget {
  final WordCategory? category;
  final bool isAll;
  final String mode;
  final List<WordCategory> allCategories;

  const StudyScreen({
    super.key,
    this.category,
    this.isAll = false,
    required this.mode,
    required this.allCategories,
  });

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  late List<WordEntry> pool;
  late WordEntry current;
  late bool showEnglish;

  final SessionStats stats = SessionStats();

  String? feedback;

  final controller = TextEditingController();
  final WordSelector selector = WordSelector();
  final Random uiRandom = Random();

  bool get isInputEmpty => controller.text.trim().isEmpty;

  bool getNextDirection() {
    if (widget.mode == 'enToPt') return true;
    if (widget.mode == 'ptToEn') return false;

    return uiRandom.nextBool();
  }

  List<WordEntry> _getAllWords(WordCategory category) {
    return [
      ...category.words,
      ...category.subcategories.expand(_getAllWords),
    ];
  }

  @override
  void initState() {
    super.initState();

    if (widget.isAll) {
      pool = widget.allCategories
          .expand(_getAllWords)
          .toList();
    } else {
      pool = _getAllWords(widget.category!);
    }

    current = pool.first;
    showEnglish = getNextDirection();

    controller.addListener(() {
      setState(() {});
    });
  }

  void checkAnswer(String answer) {
    final expected = showEnglish
        ? current.portuguese.toLowerCase()
        : current.english.toLowerCase();

    final normalized = answer.trim().toLowerCase();

    final isCorrect = normalized == expected;

    setState(() {
      stats.answerSubmitted(isCorrect: isCorrect);

      if (isCorrect) {
        feedback = '✅ Правильно!';
      } else {
        feedback = '❌ Неправильно. Правильна відповідь: $expected';
      }
    });
  }

  void nextWord() {
    setState(() {
      feedback = null;
      current = selector.nextWord(pool);
      showEnglish = getNextDirection();
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
              correct: stats.correct,
              total: stats.total,
              incorrect: stats.incorrect,
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      showEnglish ? current.english : current.portuguese,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (showEnglish && current.englishHint != null)
                      Text('Hint: ${current.englishHint}'),
                    if (!showEnglish && current.portugueseHint != null)
                      Text('Dica: ${current.portugueseHint}'),
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
