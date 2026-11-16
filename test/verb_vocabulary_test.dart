// test/vocabulary_weights_test.dart

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _regularVerbsPath = 'assets/data/vocabulary/verbs/regular_verbs.json';

const _irregularVerbsPath = 'assets/data/vocabulary/verbs/irregular_verbs.json';

const _expectedPersons = {
  'eu',
  'tu',
  'você',
  'ele',
  'ela',
  'nós',
  'eles',
  'elas',
  'vocês',
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<Map<String, dynamic>> regularVerbs;
  late List<Map<String, dynamic>> irregularVerbs;

  setUpAll(() async {
    regularVerbs = await _loadVerbs(_regularVerbsPath);
    irregularVerbs = await _loadVerbs(_irregularVerbsPath);
  });

  group('Verb vocabulary structure', () {
    test('all verbs have valid structure and all 9 persons', () {
      final allVerbs = [...regularVerbs, ...irregularVerbs];

      expect(allVerbs, isNotEmpty);

      for (final verb in allVerbs) {
        final name = verb['portuguese'];

        expect(verb['english'], isA<String>());
        expect(verb['english'].toString().trim(), isNotEmpty,
            reason: '$name: English infinitive is empty');

        expect(name, isA<String>());
        expect(name.toString().trim(), isNotEmpty);

        expect(verb['type'], 'verb', reason: '$name: type must be verb');

        expect(verb['tenses'], isA<Map>(), reason: '$name: tenses are missing');

        final tenses = verb['tenses'] as Map;
        expect(tenses['present'], isA<List>(),
            reason: '$name: present tense is missing');

        final forms = tenses['present'] as List;

        final actualPersons = forms.map((form) => form['person']).toSet();

        expect(
          actualPersons,
          _expectedPersons,
          reason: '$name: incorrect set of grammatical persons',
        );

        for (final form in forms) {
          expect(form['english'], isA<String>());
          expect(form['english'].toString().trim(), isNotEmpty,
              reason: '$name: English form is empty');

          expect(form['portuguese'], isA<String>());
          expect(form['portuguese'].toString().trim(), isNotEmpty,
              reason: '$name: Portuguese form is empty');

          expect(
            form['portuguese'].toString().trim(),
            isNot(startsWith('${form['person']} ')),
            reason: '$name: Portuguese form must not contain '
                'the pronoun ${form['person']}',
          );
        }
      }
    });
  });

  group('Duplicate verbs', () {
    test('no verb appears in both regular and irregular files', () {
      final regularNames =
          regularVerbs.map((verb) => verb['portuguese']).toSet();

      final irregularNames =
          irregularVerbs.map((verb) => verb['portuguese']).toSet();

      final duplicates = regularNames.intersection(irregularNames);

      expect(
        duplicates,
        isEmpty,
        reason: 'Duplicate verbs: ${duplicates.join(', ')}',
      );
    });
  });

  group('Irregular verb conjugations', () {
    test('ver has correct forms', () {
      _expectPortugueseForm(irregularVerbs, 'ver', 'eu', 'vejo');
      _expectPortugueseForm(irregularVerbs, 'ver', 'tu', 'vês');
    });

    test('dar has correct forms', () {
      _expectPortugueseForm(irregularVerbs, 'dar', 'eu', 'dou');
      _expectPortugueseForm(irregularVerbs, 'dar', 'eles', 'dão');
    });

    test('dormir has correct form', () {
      _expectPortugueseForm(irregularVerbs, 'dormir', 'eu', 'durmo');
    });

    test('nascer has correct form', () {
      _expectPortugueseForm(irregularVerbs, 'nascer', 'eu', 'nasço');
    });
  });
}

Future<List<Map<String, dynamic>>> _loadVerbs(String path) async {
  final jsonString = await rootBundle.loadString(path);
  final decoded = jsonDecode(jsonString) as List;

  return decoded
      .map((entry) => Map<String, dynamic>.from(entry as Map))
      .toList();
}

void _expectPortugueseForm(
  List<Map<String, dynamic>> verbs,
  String infinitive,
  String person,
  String expectedForm,
) {
  final verb = verbs.firstWhere(
    (entry) => entry['portuguese'] == infinitive,
    orElse: () => throw StateError('Verb $infinitive not found'),
  );

  final forms = verb['tenses']['present'] as List;

  final form = forms.firstWhere(
    (entry) => entry['person'] == person,
    orElse: () => throw StateError(
      'Person $person not found for $infinitive',
    ),
  );

  expect(
    form['portuguese'],
    expectedForm,
    reason: 'Incorrect $person form of $infinitive',
  );
}
