// widgets/session_statistics.dart

import 'package:material_ui/material_ui.dart';

class SessionStatistics extends StatelessWidget {
  final int correct;
  final int total;
  final int incorrect;

  const SessionStatistics({
    super.key,
    required this.correct,
    required this.total,
    required this.incorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('✅ $correct'),
        Text('📖 $total'),
        Text('❌ $incorrect'),
      ],
    );
  }
}
