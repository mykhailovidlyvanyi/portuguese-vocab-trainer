// data/words_data.dart
import '../models/word_entry.dart';
import '../models/word_category.dart';

final categories = [
  WordCategory(
    name: 'Неправильні Дієслова',
    words: [
      // Ser
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
      // Ir
      WordEntry(english: "to go", portuguese: "ir",  weight: 1.0),
      WordEntry(english: "I go", portuguese: "eu vou", weight: 1.0),
      WordEntry(english: "you go", portuguese: "você vai", englishHint: "singular, formal", portugueseHint: "singular, formal", weight: 0.25),
      WordEntry(english: "he goes", portuguese: "ele vai", weight: 0.25),
      WordEntry(english: "she goes", portuguese: "ela vai", weight: 0.25),
      WordEntry(english: "you go", portuguese: "tu vais", englishHint: "singular, informal", portugueseHint: "singular, informal", weight: 0.25),
      WordEntry(english: "we go", portuguese: "nós vamos", weight: 1.0),
      WordEntry(english: "they go", portuguese: "eles vão", weight: 0.33),
      WordEntry(english: "they go", portuguese: "elas vão", weight: 0.33),
      WordEntry(english: "you go", portuguese: "vocês vão", englishHint: "plural", portugueseHint: "plural", weight: 0.33),
      // Fazer
      WordEntry(english: "to do", portuguese: "Fazer",  weight: 1.0),
      WordEntry(english: "I do", portuguese: "eu faço", weight: 1.0),
      WordEntry(english: "you do", portuguese: "você faz", englishHint: "singular, formal", portugueseHint: "singular, formal", weight: 0.25),
      WordEntry(english: "he does", portuguese: "ele faz", weight: 0.25),
      WordEntry(english: "she does", portuguese: "ela faz", weight: 0.25),
      WordEntry(english: "you do", portuguese: "tu fazes", englishHint: "singular, informal", portugueseHint: "singular, informal", weight: 0.25),
      WordEntry(english: "we do", portuguese: "nós fazemos", weight: 1.0),
      WordEntry(english: "they do", portuguese: "eles fazem", weight: 0.33),
      WordEntry(english: "they do", portuguese: "elas fazem", weight: 0.33),
      WordEntry(english: "you do", portuguese: "vocês fazem", englishHint: "plural", portugueseHint: "plural", weight: 0.33),
      // Dizer
      WordEntry(english: "to say", portuguese: "Dizer",  weight: 1.0),
      WordEntry(english: "I say", portuguese: "eu digo", weight: 1.0),
      WordEntry(english: "you say", portuguese: "você diz", englishHint: "singular, formal", portugueseHint: "singular, formal", weight: 0.25),
      WordEntry(english: "he says", portuguese: "ele diz", weight: 0.25),
      WordEntry(english: "she says", portuguese: "ela diz", weight: 0.25),
      WordEntry(english: "you say", portuguese: "tu dizes", englishHint: "singular, informal", portugueseHint: "singular, informal", weight: 0.25),
      WordEntry(english: "we say", portuguese: "nós dizemos", weight: 1.0),
      WordEntry(english: "they say", portuguese: "eles dizem", weight: 0.33),
      WordEntry(english: "they say", portuguese: "elas dizem", weight: 0.33),
      WordEntry(english: "you say", portuguese: "vocês dizem", englishHint: "plural", portugueseHint: "plural", weight: 0.33),
      // Vir
      WordEntry(english: "to come", portuguese: "vir", weight: 1.0),
      WordEntry(english: "I come", portuguese: "eu venho", weight: 1.0),
      WordEntry(english: "you come", portuguese: "você vem", englishHint: "singular, formal", portugueseHint: "singular, formal", weight: 0.33),
      WordEntry(english: "he comes", portuguese: "ele vem", weight: 0.33),
      WordEntry(english: "she comes", portuguese: "ela vem", weight: 0.33),
      WordEntry(english: "you come", portuguese: "tu vens", englishHint: "singular, informal", portugueseHint: "singular, informal", weight: 1.0),
      WordEntry(english: "we come", portuguese: "nós vimos", weight: 1.0),
      WordEntry(english: "they come", portuguese: "eles vêm", weight: 0.33),
      WordEntry(english: "they come", portuguese: "elas vêm", weight: 0.33),
      WordEntry(english: "you come", portuguese: "vocês vêm", englishHint: "plural", portugueseHint: "plural", weight: 0.33),
      // Poder
      WordEntry(english: "can", portuguese: "poder", weight: 1.0),
      WordEntry(english: "I can", portuguese: "eu posso", weight: 1.0),
      WordEntry(english: "you can", portuguese: "você pode", englishHint: "singular, formal", portugueseHint: "singular, formal", weight: 0.33),
      WordEntry(english: "he can", portuguese: "ele pode", weight: 0.33),
      WordEntry(english: "she can", portuguese: "ela pode", weight: 0.33),
      WordEntry(english: "you can", portuguese: "tu podes", englishHint: "singular, informal", portugueseHint: "singular, informal", weight: 1.0),
      WordEntry(english: "we can", portuguese: "nós podemos", weight: 1.0),
      WordEntry(english: "they can", portuguese: "eles podem", weight: 0.33),
      WordEntry(english: "they can", portuguese: "elas podem", weight: 0.33),
      WordEntry(english: "you can", portuguese: "vocês podem", englishHint: "plural", portugueseHint: "plural", weight: 0.33),
      // Querer
      WordEntry(english: "to want", portuguese: "querer", weight: 1.0),
      WordEntry(english: "I want", portuguese: "eu quero", weight: 1.0),
      WordEntry(english: "you want", portuguese: "você quer", englishHint: "singular, formal", portugueseHint: "singular, formal", weight: 0.33),
      WordEntry(english: "he wants", portuguese: "ele quer", weight: 0.33),
      WordEntry(english: "she wants", portuguese: "ela quer", weight: 0.33),
      WordEntry(english: "you want", portuguese: "tu queres", englishHint: "singular, informal", portugueseHint: "singular, informal", weight: 1.0),
      WordEntry(english: "we want", portuguese: "nós queremos", weight: 1.0),
      WordEntry(english: "they want", portuguese: "eles querem", weight: 0.33),
      WordEntry(english: "they want", portuguese: "elas querem", weight: 0.33),
      WordEntry(english: "you want", portuguese: "vocês querem", englishHint: "plural", portugueseHint: "plural", weight: 0.33),
      // Saber
      WordEntry(english: "to know", portuguese: "saber", weight: 1.0),
      WordEntry(english: "I know", portuguese: "eu sei", weight: 1.0),
      WordEntry(english: "you know", portuguese: "você sabe", englishHint: "singular, formal", portugueseHint: "singular, formal", weight: 0.33),
      WordEntry(english: "he knows", portuguese: "ele sabe", weight: 0.33),
      WordEntry(english: "she knows", portuguese: "ela sabe", weight: 0.33),
      WordEntry(english: "you know", portuguese: "tu sabes", englishHint: "singular, informal", portugueseHint: "singular, informal", weight: 1.0),
      WordEntry(english: "we know", portuguese: "nós sabemos", weight: 1.0),
      WordEntry(english: "they know", portuguese: "eles sabem", weight: 0.33),
      WordEntry(english: "they know", portuguese: "elas sabem", weight: 0.33),
      WordEntry(english: "you know", portuguese: "vocês sabem", englishHint: "plural", portugueseHint: "plural", weight: 0.33),
    ],
  ),

  WordCategory(
    name: 'Числівники',
    subcategories: [
      WordCategory(
        name: 'Кількісні',
        subcategories: [
          WordCategory(
        name: '0–10',
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
          WordCategory(
        name: '11–20',
        words: [
          WordEntry(english: "eleven", portuguese: "onze", numericValue: 11, weight: 1.0),
          WordEntry(english: "twelve", portuguese: "doze", numericValue: 12, weight: 1.0),
          WordEntry(english: "thirteen", portuguese: "treze", numericValue: 13, weight: 1.0),
          WordEntry(english: "fourteen", portuguese: "catorze", numericValue: 14, weight: 1.0),
          WordEntry(english: "fifteen", portuguese: "quinze", numericValue: 15, weight: 1.0),
          WordEntry(english: "sixteen", portuguese: "dezasseis", numericValue: 16, weight: 1.0),
          WordEntry(english: "seventeen", portuguese: "dezassete", numericValue: 17, weight: 1.0),
          WordEntry(english: "eighteen", portuguese: "dezoito", numericValue: 18, weight: 1.0),
          WordEntry(english: "nineteen", portuguese: "dezanove", numericValue: 19, weight: 1.0),
        ],
      ),
          WordCategory(
        name: 'Десятки',
        words: [
          WordEntry(english: "twenty", portuguese: "vinte", numericValue: 20, weight: 1.0),
          WordEntry(english: "thirty", portuguese: "trinta", numericValue: 30, weight: 1.0),
          WordEntry(english: "forty", portuguese: "quarenta", numericValue: 40, weight: 1.0),
          WordEntry(english: "fifty", portuguese: "cinquenta", numericValue: 50, weight: 1.0),
          WordEntry(english: "sixty", portuguese: "sessenta", numericValue: 60, weight: 1.0),
          WordEntry(english: "seventy", portuguese: "setenta", numericValue: 70, weight: 1.0),
          WordEntry(english: "eighty", portuguese: "oitenta", numericValue: 80, weight: 1.0),
          WordEntry(english: "ninety", portuguese: "noventa", numericValue: 90, weight: 1.0),
        ],
      ),
          WordCategory(
        name: 'Сотні',
        words: [
          WordEntry(english: "one hundred", portuguese: "cem", numericValue: 100, weight: 1.0),
          WordEntry(english: "two hundred", portuguese: "duzentos", numericValue: 200, weight: 1.0),
          WordEntry(english: "three hundred", portuguese: "trezentos", numericValue: 300, weight: 1.0),
          WordEntry(english: "four hundred", portuguese: "quatrocentos", numericValue: 400, weight: 1.0),
          WordEntry(english: "five hundred", portuguese: "quinhentos", numericValue: 500, weight: 1.0),
          WordEntry(english: "six hundred", portuguese: "seiscentos", numericValue: 600, weight: 1.0),
          WordEntry(english: "seven hundred", portuguese: "setecentos", numericValue: 700, weight: 1.0),
          WordEntry(english: "eight hundred", portuguese: "oitocentos", numericValue: 800, weight: 1.0),
          WordEntry(english: "nine hundred", portuguese: "novecentos", numericValue: 900, weight: 1.0),
        ],
      ),
        ],
      ),
      WordCategory(
        name: 'Порядкові',
        subcategories: [
          WordCategory(
            name: '1–10',
            words: [
              WordEntry(english: "first", portuguese: "primeiro", numericValue: 1, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "first", portuguese: "primeira", numericValue: 1, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "second", portuguese: "segundo", numericValue: 2, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "second", portuguese: "segunda", numericValue: 2, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "third", portuguese: "terceiro", numericValue: 3, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "third", portuguese: "terceira", numericValue: 3, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "fourth", portuguese: "quarto", numericValue: 4, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "fourth", portuguese: "quarta", numericValue: 4, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "fifth", portuguese: "quinto", numericValue: 5, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "fifth", portuguese: "quinta", numericValue: 5, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "sixth", portuguese: "sexto", numericValue: 6, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "sixth", portuguese: "sexta", numericValue: 6, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "seventh", portuguese: "sétimo", numericValue: 7, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "seventh", portuguese: "sétima", numericValue: 7, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "eighth", portuguese: "oitavo", numericValue: 8, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "eighth", portuguese: "oitava", numericValue: 8, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "ninth", portuguese: "nono", numericValue: 9, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "ninth", portuguese: "nona", numericValue: 9, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "tenth", portuguese: "décimo", numericValue: 10, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "tenth", portuguese: "décima", numericValue: 10, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),
            ],
          ),
          WordCategory(
            name: '11–19',
            words: [
              WordEntry(english: "eleventh", portuguese: "décimo primeiro", numericValue: 11, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "eleventh", portuguese: "décima primeira", numericValue: 11, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "twelfth", portuguese: "décimo segundo", numericValue: 12, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "twelfth", portuguese: "décima segunda", numericValue: 12, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "thirteenth", portuguese: "décimo terceiro", numericValue: 13, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "thirteenth", portuguese: "décima terceira", numericValue: 13, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "fourteenth", portuguese: "décimo quarto", numericValue: 14, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "fourteenth", portuguese: "décima quarta", numericValue: 14, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "fifteenth", portuguese: "décimo quinto", numericValue: 15, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "fifteenth", portuguese: "décima quinta", numericValue: 15, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "sixteenth", portuguese: "décimo sexto", numericValue: 16, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "sixteenth", portuguese: "décima sexta", numericValue: 16, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "seventeenth", portuguese: "décimo sétimo", numericValue: 17, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "seventeenth", portuguese: "décima sétima", numericValue: 17, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "eighteenth", portuguese: "décimo oitavo", numericValue: 18, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "eighteenth", portuguese: "décima oitava", numericValue: 18, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),

              WordEntry(english: "nineteenth", portuguese: "décimo nono", numericValue: 19, englishHint: "masculine", portugueseHint: "masculino", weight: 0.5),
              WordEntry(english: "nineteenth", portuguese: "décima nona", numericValue: 19, englishHint: "feminine", portugueseHint: "feminino", weight: 0.5),
            ],
          ),
        ],
      ),
    ],
  ),
];