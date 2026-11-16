// lib/screens/typing_study_screen.dart

import 'package:material_ui/material_ui.dart';

import '../models/word_category.dart';

import '../config/app_environment.dart';

import '../utils/study_session.dart';
import '../utils/word_pool_builder.dart';

import '../widgets/session_statistics.dart';

import 'exercise_type_selection_screen.dart';

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
  String? userAnswer;
  bool didNotKnow = false;

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
      userAnswer = answer.trim();
      didNotKnow = answer.isEmpty;

      if (didNotKnow) {
        feedback = '❌ Правильна відповідь: ${session.expectedAnswer}';
      } else if (isCorrect) {
        feedback = '✅ Правильно!';
      } else {
        feedback = '❌ Неправильно!';
      }
    });
  }

  void nextWord() {
    setState(() {
      feedback = null;
      userAnswer = null;
      didNotKnow = false;
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
    final pronoun = session.currentPronoun;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppEnvironment.screenTitle('$categoryName — Навчання'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => ExerciseTypeSelectionScreen(
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
              if (pronoun != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        pronoun,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: 'Введіть форму дієслова',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: isInputEmpty ? null : checkAnswer,
                      ),
                    ),
                  ],
                )
              else
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
              if (!didNotKnow)
                Text(
                  'Твоя відповідь: $userAnswer',
                  style: const TextStyle(fontSize: 18),
                ),
              const SizedBox(height: 8),
              Text(
                didNotKnow
                    ? feedback!
                    : feedback == '❌ Неправильно!'
                        ? '❌ Неправильно! Правильна відповідь: ${session.expectedAnswer}'
                        : feedback!,
                style: const TextStyle(fontSize: 20),
              ),
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
