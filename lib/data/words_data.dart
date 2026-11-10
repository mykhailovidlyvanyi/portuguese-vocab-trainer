// data/words_data.dart
import '../models/word_entry.dart';
import '../models/word_category.dart';

final categories = [
  WordCategory(
    name: 'Неправильні Дієслова',
    words: [
      // Irregular verbs (Неправильні Дієслова)
      WordEntry(english: "to be", portuguese: "ser", englishHint: "permanent", portugueseHint: "permanente", weight: 1.0),
      WordEntry(english: "I am", portuguese: "eu sou", englishHint: "permanent", portugueseHint: "permanente", weight: 1.0),
      WordEntry(english: "you are", portuguese: "você é", englishHint: "permanent, formal", portugueseHint: "permanente, formal", weight: 0.25),
      WordEntry(english: "he is", portuguese: "ele é", englishHint: "permanent", portugueseHint: "permanente", weight: 0.25),
      WordEntry(english: "she is", portuguese: "ela é", englishHint: "permanent", portugueseHint: "permanente", weight: 0.25),
      WordEntry(english: "you are", portuguese: "tu és", englishHint: "permanent, informal", portugueseHint: "permanente, informal", weight: 0.25),
      WordEntry(english: "we are", portuguese: "nós somos", englishHint: "permanent", portugueseHint: "perманente", weight: 1.0),
      WordEntry(english: "they are", portuguese: "eles são", englishHint: "permanent", portugueseHint: "permanente", weight: 0.33),
      WordEntry(english: "they are", portuguese: "elas são", englishHint: "permanent", portugueseHint: "permanente", weight: 0.33),
      WordEntry(english: "you are", portuguese: "vocês são", englishHint: "permanent, plural", portugueseHint: "permanente, plural", weight: 0.33),
      // Estar
      WordEntry(english: "to be", portuguese: "estar", englishHint: "temporary", portugueseHint: "temporário", weight: 1.0),
      WordEntry(english: "I am", portuguese: "eu estou", englishHint: "temporary", portugueseHint: "temporário", weight: 1.0),
      WordEntry(english: "you are", portuguese: "você está", englishHint: "temporary, formal", portugueseHint: "temporário, formal", weight: 0.25),
      WordEntry(english: "he is", portuguese: "ele está", englishHint: "temporary", portugueseHint: "temporário", weight: 0.25),
      WordEntry(english: "she is", portuguese: "ela está", englishHint: "temporary", portugueseHint: "temporário", weight: 0.25),
      WordEntry(english: "you are", portuguese: "tu estás", englishHint: "temporary, informal", portugueseHint: "temporário, informal", weight: 0.25),
      WordEntry(english: "we are", portuguese: "nós estamos", englishHint: "temporary", portugueseHint: "temporário", weight: 1.0),
      WordEntry(english: "they are", portuguese: "eles estão", englishHint: "temporary", portugueseHint: "temporário", weight: 0.33),
      WordEntry(english: "they are", portuguese: "elas estão", englishHint: "temporary", portugueseHint: "temporário", weight: 0.33),
      WordEntry(english: "you are", portuguese: "vocês estão", englishHint: "temporary, plural", portugueseHint: "temporário, plural", weight: 0.33),
      // Ter
      WordEntry(english: "to have", portuguese: "ter",  weight: 1.0),
      WordEntry(english: "I have", portuguese: "eu tenho", weight: 1.0),
      WordEntry(english: "you have", portuguese: "você tem", englishHint: "singular, formal", portugueseHint: "singular, formal", weight: 0.25),
      WordEntry(english: "he has", portuguese: "ele tem", weight: 0.25),
      WordEntry(english: "she has", portuguese: "ela tem", weight: 0.25),
      WordEntry(english: "you have", portuguese: "tu tens", englishHint: "singular, informal", portugueseHint: "singular, informal", weight: 0.25),
      WordEntry(english: "we have", portuguese: "nós temos", weight: 1.0),
      WordEntry(english: "they have", portuguese: "eles têm", weight: 0.33),
      WordEntry(english: "they have", portuguese: "elas têm", weight: 0.33),
      WordEntry(english: "you have", portuguese: "vocês têm", englishHint: "plural", portugueseHint: "plural", weight: 0.33),
    ],
  ),
  WordCategory(
    name: 'Числівники',
    words: [
      WordEntry(english: "zero", portuguese: "zero", numericValue: 0, weight: 1.0),
      WordEntry(english: "one", portuguese: "um", numericValue: 1, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
      WordEntry(english: "one", portuguese: "uma", numericValue: 1, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),
      WordEntry(english: "two", portuguese: "dois", numericValue: 2, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
      WordEntry(english: "two", portuguese: "duas", numericValue: 2, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),
      WordEntry(english: "three", portuguese: "três", numericValue: 3, weight: 1.0),
      WordEntry(english: "four", portuguese: "quatro", numericValue: 4, weight: 1.0),
      WordEntry(english: "five", portuguese: "cinco", numericValue: 5, weight: 1.0),
      WordEntry(english: "six", portuguese: "seis", numericValue: 6, weight: 1.0),
      WordEntry(english: "seven", portuguese: "sete", numericValue: 7, weight: 1.0),
      WordEntry(english: "eight", portuguese: "oito", numericValue: 8, weight: 1.0),
      WordEntry(english: "nine", portuguese: "nove", numericValue: 9, weight: 1.0),
      WordEntry(english: "ten", portuguese: "dez", numericValue: 10, weight: 1.0),
    ],
  ),
];
