// utils/session_stats.dart

class SessionStats {
  int correct = 0;
  int incorrect = 0;
  int total = 0;

  void answerSubmitted({required bool isCorrect}) {
    total++;

    if (isCorrect) {
      correct++;
    } else {
      incorrect++;
    }
  }
}