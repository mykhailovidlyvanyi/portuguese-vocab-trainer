// lib/screens/multiple_choice_study_screen.dart

import 'package:material_ui/material_ui.dart';
import 'dart:math';

import '../models/word_category.dart';
import '../models/word_entry.dart';

import '../utils/conjugation_question_builder.dart';
import '../utils/multiple_choice_options_builder.dart';
import '../utils/study_session.dart';
import '../utils/word_pool_builder.dart';
import '../utils/session_stats.dart';

import '../widgets/session_statistics.dart';

import 'exercise_type_selection_screen.dart';

class MultipleChoiceStudyScreen extends StatefulWidget {
  final WordCategory? category;
  final bool isAll;
  final String mode;
  final List<WordCategory> allCategories;
  final String exerciseMode;

  const MultipleChoiceStudyScreen({
    super.key,
    this.category,
    this.isAll = false,
    required this.mode,
    required this.allCategories,
    this.exerciseMode = 'translation',
  });

  @override
  State<MultipleChoiceStudyScreen> createState() =>
      _MultipleChoiceStudyScreenState();
}

class _MultipleChoiceStudyScreenState extends State<MultipleChoiceStudyScreen> {
  late final List<WordEntry> _pool;

  StudySession? _session;
  List<String> _options = [];

  List<ConjugationQuestion> _conjugationQuestions = [];
  ConjugationQuestion? _currentConjugationQuestion;
  bool _showEnglishConjugationPrompt = true;

  final Random _random = Random();

  final SessionStats _conjugationStats = SessionStats();

  String? _selectedAnswer;
  String? _errorMessage;

  final MultipleChoiceOptionsBuilder _optionsBuilder =
      MultipleChoiceOptionsBuilder();

  final ConjugationQuestionBuilder _conjugationBuilder =
      ConjugationQuestionBuilder();

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

    if (widget.exerciseMode == 'conjugation') {
      _initializeConjugationSession();
      return;
    }

    _initializeTranslationSession();
  }

  void _initializeTranslationSession() {
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

  void _initializeConjugationSession() {
    if (!['enToPt', 'ptToPt', 'mixed'].contains(widget.mode)) {
      _errorMessage = 'Недоступний напрямок для режиму відмінювання.';
      return;
    }
    _conjugationQuestions = _conjugationBuilder.buildQuestions(
      pool: _pool,
    );

    if (_conjugationQuestions.isEmpty) {
      _errorMessage =
          'Недостатньо дієслів для тесту. Потрібні дієслова щонайменше з чотирма різними формами.';
      return;
    }

    _nextConjugationQuestion();
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

  void _nextConjugationQuestion() {
    _currentConjugationQuestion =
        _conjugationBuilder.nextQuestion(_conjugationQuestions);

    _showEnglishConjugationPrompt = switch (widget.mode) {
      'enToPt' => true,
      'ptToPt' => false,
      'mixed' => _random.nextBool(),
      _ => true,
    };

    _options = _currentConjugationQuestion!.options;
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

      if (widget.exerciseMode == 'conjugation') {
        final isCorrect = answer.trim().toLowerCase() ==
            _currentConjugationQuestion!.correctAnswer.trim().toLowerCase();

        _conjugationStats.answerSubmitted(isCorrect: isCorrect);
      } else {
        _session!.checkAnswer(answer);
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (widget.exerciseMode == 'conjugation') {
        _nextConjugationQuestion();
      } else {
        _session!.nextWord();
        _buildOptions();
      }

      _selectedAnswer = null;
    });
  }

  void _exitExercise() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseTypeSelectionScreen(
          categories: widget.allCategories,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.isAll ? 'Усе' : widget.category!.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _errorMessage != null
              ? 'Multiple Choice'
              : '$categoryName — Навчання',
        ),
        actions: [
          if (_errorMessage == null)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: _exitExercise,
            ),
        ],
      ),
      body: _errorMessage != null
          ? _buildErrorContent()
          : widget.exerciseMode == 'conjugation'
              ? _buildConjugationContent()
              : _buildStudyContent(_session!),
    );
  }

  Widget _buildErrorContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _exitExercise,
              icon: const Icon(Icons.arrow_back),
              label: const Text('До вибору вправ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConjugationContent() {
    final question = _currentConjugationQuestion!;

    return _buildQuestionContent(
      questionText: _showEnglishConjugationPrompt
          ? question.englishInfinitive
          : question.infinitive,
      subtitle: _showEnglishConjugationPrompt
          ? question.englishPerson
          : question.person,
      stats: _conjugationStats,
      expectedAnswer: question.correctAnswer,
    );
  }

  Widget _buildStudyContent(StudySession session) {
    return _buildQuestionContent(
      questionText: _question,
      stats: session.stats,
      expectedAnswer: session.expectedAnswer,
      hint: session.showEnglish
          ? session.current.englishHint == null
              ? null
              : 'Hint: ${session.current.englishHint}'
          : session.current.portugueseHint == null
              ? null
              : 'Dica: ${session.current.portugueseHint}',
    );
  }

  Widget _buildQuestionContent({
    required String questionText,
    required SessionStats stats,
    required String expectedAnswer,
    String? hint,
    String? subtitle,
  }) {
    final normalizedSelectedAnswer = _selectedAnswer?.trim().toLowerCase();
    final normalizedExpectedAnswer = expectedAnswer.trim().toLowerCase();

    return Padding(
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
                    questionText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                  if (hint != null) Text(hint),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ..._options.map((option) {
            Color backgroundColor = Colors.grey.shade200;

            final normalizedOption = option.trim().toLowerCase();

            if (normalizedSelectedAnswer != null) {
              if (normalizedOption == normalizedExpectedAnswer) {
                backgroundColor = Colors.green.shade300;
              } else if (normalizedOption == normalizedSelectedAnswer) {
                backgroundColor = Colors.red.shade300;
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
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
    );
  }
}
