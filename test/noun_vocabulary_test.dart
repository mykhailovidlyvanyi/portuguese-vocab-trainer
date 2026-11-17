// test/noun_vocabulary_test.dart

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _daysPath = 'assets/data/vocabulary/nouns/days_of_week.json';
const _monthsPath = 'assets/data/vocabulary/nouns/months.json';
const _seasonsPath = 'assets/data/vocabulary/nouns/seasons.json';
const _genderDataPath = 'assets/data/gender_data.json';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<Map<String, dynamic>> days;
  late List<Map<String, dynamic>> months;
  late List<Map<String, dynamic>> seasons;
  late Map<String, dynamic> genderData;

  setUpAll(() async {
    days = await _loadWords(_daysPath);
    months = await _loadWords(_monthsPath);
    seasons = await _loadWords(_seasonsPath);
    genderData = await _loadGenderData();
  });

  group('Noun vocabulary structure', () {
    test('contains 23 nouns across all categories', () {
      expect(days, hasLength(7));
      expect(months, hasLength(12));
      expect(seasons, hasLength(4));

      final allWords = [...days, ...months, ...seasons];

      expect(allWords, hasLength(23));
    });

    test('all nouns have valid structure and gender', () {
      final allWords = [...days, ...months, ...seasons];

      for (final word in allWords) {
        final name = word['portuguese'];

        expect(word['english'], isA<String>());
        expect(word['english'].toString().trim(), isNotEmpty,
            reason: '$name: English translation is empty');

        expect(name, isA<String>());
        expect(name.toString().trim(), isNotEmpty);

        expect(word['type'], 'noun', reason: '$name: type must be noun');

        expect(
          genderData.containsKey(word['gender']),
          isTrue,
          reason: '$name: invalid or missing gender',
        );
      }
    });

    test('all genders have corresponding articles', () {
      expect(genderData['masculine']['article'], 'o');
      expect(genderData['feminine']['article'], 'a');
    });
  });

  group('Days of the week', () {
    test('have correct genders', () {
      final expectedGenders = {
        'segunda-feira': 'feminine',
        'terça-feira': 'feminine',
        'quarta-feira': 'feminine',
        'quinta-feira': 'feminine',
        'sexta-feira': 'feminine',
        'sábado': 'masculine',
        'domingo': 'masculine',
      };

      _expectGenders(days, expectedGenders);
    });
  });

  group('Months', () {
    test('all months are masculine', () {
      for (final month in months) {
        expect(
          month['gender'],
          'masculine',
          reason: '${month['portuguese']} must be masculine',
        );
      }
    });
  });

  group('Seasons', () {
    test('have correct genders', () {
      final expectedGenders = {
        'primavera': 'feminine',
        'verão': 'masculine',
        'outono': 'masculine',
        'inverno': 'masculine',
      };

      _expectGenders(seasons, expectedGenders);
    });
  });
}

Future<List<Map<String, dynamic>>> _loadWords(String path) async {
  final jsonString = await rootBundle.loadString(path);
  final decoded = jsonDecode(jsonString) as List;

  return decoded
      .map((entry) => Map<String, dynamic>.from(entry as Map))
      .toList();
}

Future<Map<String, dynamic>> _loadGenderData() async {
  final jsonString = await rootBundle.loadString(_genderDataPath);
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void _expectGenders(
  List<Map<String, dynamic>> words,
  Map<String, String> expectedGenders,
) {
  for (final entry in expectedGenders.entries) {
    final word = words.firstWhere(
      (word) => word['portuguese'] == entry.key,
      orElse: () => throw StateError('Word ${entry.key} not found'),
    );

    expect(
      word['gender'],
      entry.value,
      reason: 'Incorrect gender for ${entry.key}',
    );
  }
}
