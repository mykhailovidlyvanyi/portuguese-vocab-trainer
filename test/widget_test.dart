
import 'package:flutter_test/flutter_test.dart';

import 'package:portuguese_vocab_trainer/main.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const PortugueseVocabApp());

    expect(find.byType(PortugueseVocabApp), findsOneWidget);
  });
}
