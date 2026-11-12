// services/vocabulary_service.dart

import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/word_category.dart';
import '../models/word_entry.dart';

class VocabularyService {
  Future<List<WordCategory>> loadCategories() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/categories.json',
    );

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return Future.wait(
      jsonList.map(
            (item) => _parseCategory(item as Map<String, dynamic>),
      ),
    );
  }

  Future<WordCategory> _parseCategory(
      Map<String, dynamic> json,
      ) async {
    final wordsFile = json['wordsFile'] as String?;

    final List<WordEntry> words = wordsFile == null
        ? []
        : await _loadWords(wordsFile);

    final List<dynamic> subcategoriesJson =
        json['subcategories'] as List<dynamic>? ?? [];

    final subcategories = await Future.wait(
      subcategoriesJson.map(
            (item) => _parseCategory(item as Map<String, dynamic>),
      ),
    );

    return WordCategory(
      name: json['name'] as String,
      words: words,
      subcategories: subcategories,
    );
  }

  Future<List<WordEntry>> _loadWords(String filePath) async {
    final jsonString = await rootBundle.loadString(
      'assets/data/$filePath',
    );

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList
        .map(
          (item) => WordEntry.fromJson(item as Map<String, dynamic>),
    )
        .toList();
  }
}
