// screens/study_screen.dart

import 'package:flutter/material.dart';
import '../models/word_entry.dart';
import '../models/word_category.dart';
import '../data/words_data.dart';
import '../utils/word_selector.dart';
import 'category_selection_screen.dart';
import 'dart:math';

class StudyScreen extends StatefulWidget {
  final WordCategory? category;
  final bool isAll;
  final String mode;

  const StudyScreen({
    super.key,
    this.category,
    this.isAll = false,
    required this.mode,
  });

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  late List<WordEntry> pool;
  late WordEntry current;
  int correct = 0;
  int total = 0;
  int incorrect = 0;
  String? feedback;
  final controller = TextEditingController();
  final WordSelector selector = WordSelector();
  final Random uiRandom = Random();

  bool get isInputEmpty => controller.text.trim().isEmpty;

  @override
  void initState() {
    super.initState();

    if (widget.isAll) {
      pool = categories.expand((c) {
        if (c.subcategories.isNotEmpty) {
          return c.subcategories.expand((sub) => sub.words);
        }
        return c.words;
      }).toList();
    } else {
      pool = widget.category!.words;
    }

    current = pool.first;

    controller.addListener(() {
      setState(() {});
    });
  }

  void checkAnswer(String answer) {
    final expected = widget.mode == 'ptToEn'
        ? current.english.toLowerCase()
        : current.portuguese.toLowerCase();

    final normalized = answer.trim().toLowerCase();

    final isCorrect = normalized == expected;
    setState(() {
      total++;
      if (isCorrect) {
        correct++;
        feedback = '✅ Правильно!';
      } else {
        incorrect++;
        feedback = '❌ Неправильно. Правильна відповідь: $expected';
      }
    });
  }

  void nextWord() {
    setState(() {
      feedback = null;
      current = selector.nextWord(pool);
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
    final showEnglish = widget.mode == 'enToPt' ||
        (widget.mode == 'mixed' && uiRandom.nextBool());

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
                builder: (_) => const CategorySelectionScreen(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('✅ $correct'),
                Text('📖 $total'),
                Text('❌ $incorrect'),
              ],
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
