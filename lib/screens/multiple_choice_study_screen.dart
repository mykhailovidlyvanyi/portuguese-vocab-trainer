// lib/screens/multiple_choice_study_screen.dart

import 'package:material_ui/material_ui.dart';

import '../models/word_category.dart';
import '../models/word_entry.dart';

import '../utils/multiple_choice_options_builder.dart';
import '../utils/study_session.dart';
import '../utils/word_pool_builder.dart';

import '../widgets/session_statistics.dart';

import 'exercise_type_selection_screen.dart';

class MultipleChoiceStudyScreen extends StatefulWidget {
  final WordCategory? category;
  final bool isAll;
  final String mode;
  final List<WordCategory> allCategories;

  const MultipleChoiceStudyScreen({
    super.key,
    this.category,
    this.isAll = false,
    required this.mode,
    required this.allCategories,
  });

  @override
  State<MultipleChoiceStudyScreen> createState() =>
      _MultipleChoiceStudyScreenState();
}

class _MultipleChoiceStudyScreenState extends State<MultipleChoiceStudyScreen> {
  late final List<WordEntry> _pool;

  StudySession? _session;
  List<String> _options = [];

  String? _selectedAnswer;

  String? _errorMessage;

  final MultipleChoiceOptionsBuilder _optionsBuilder =
      MultipleChoiceOptionsBuilder();

  @override
  void initState() {
    super.initState();

    _initializeSession();
  }

  void _initializeSession() {
    final poolBuilder = WordPoolBuilder();

    _pool = widget.isAll
        ? poolBuilder.fromCategoriesInfinitives(widget.allCategories)
        : poolBuilder.fromCategoryInfinitives(widget.category!);

    final hasEnoughAnswers = switch (widget.mode) {
      'enToPt' => _hasEnoughUniqueAnswers(true),
      'ptToEn' => _hasEnoughUniqueAnswers(false),
      _ => _hasEnoughUniqueAnswers(true) && _hasEnoughUniqueAnswers(false),
    };

    if (!hasEnoughAnswers) {
      _errorMessage =
          'Недостатньо слів для тесту. Потрібно щонайменше 4 різні відповіді.';
      return;
    }

    _session = StudySession(
      pool: _pool,
      mode: widget.mode,
    );

    _buildOptions();
  }

  bool _hasEnoughUniqueAnswers(bool showEnglish) {
    final answers = _pool
        .map(
          (word) => (showEnglish ? word.portuguese : word.english)
              .trim()
              .toLowerCase(),
        )
        .where((answer) => answer.isNotEmpty)
        .toSet();

    return answers.length >= 4;
  }

  void _buildOptions() {
    final session = _session!;

    _options = _optionsBuilder.buildOptions(
      pool: session.pool,
      correctWord: session.current,
      showEnglish: session.showEnglish,
    );
  }

  String get _question {
    final session = _session!;

    return session.showEnglish
        ? session.current.english
        : session.current.portuguese;
  }

  void _selectAnswer(String answer) {
    if (_selectedAnswer != null) return;

    setState(() {
      _selectedAnswer = answer;
      _session!.checkAnswer(answer);
    });
  }

  void _nextQuestion() {
    setState(() {
      _session!.nextWord();
      _selectedAnswer = null;
      _buildOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.isAll ? 'Усе' : widget.category!.name;

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Multiple Choice'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
    }

    final session = _session!;

    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName — Навчання'),
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
          ),
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
                      _question,
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
            ..._options.map((option) {
              Color? backgroundColor;

              if (_selectedAnswer != null) {
                if (option.trim().toLowerCase() ==
                    session.expectedAnswer.trim().toLowerCase()) {
                  backgroundColor = option == _selectedAnswer
                      ? Colors.green.shade700
                      : Colors.green.shade300;
                } else if (option == _selectedAnswer) {
                  backgroundColor = Colors.red.shade300;
                } else {
                  backgroundColor = Colors.grey.shade200;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: backgroundColor == null
                      ? null
                      : ElevatedButton.styleFrom(
                          backgroundColor: backgroundColor,
                          disabledBackgroundColor: backgroundColor,
                          disabledForegroundColor: Colors.black87,
                        ),
                  onPressed: _selectedAnswer == null
                      ? () => _selectAnswer(option)
                      : null,
                  child: Text(option),
                ),
              );
            }),
            if (_selectedAnswer != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _nextQuestion,
                child: const Text('Продовжити'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
