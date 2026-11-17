// lib/models/study_weight.dart

class StudyWeight {
  final double baseWeight;
  final double learningMultiplier;

  const StudyWeight({
    this.baseWeight = 1.0,
    this.learningMultiplier = 1.0,
  });

  double get effectiveWeight => baseWeight * learningMultiplier;
}