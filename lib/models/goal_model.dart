class GoalModel {
  final int steps;

  GoalModel({
    required this.steps,
  });

  Map<String, dynamic> toMap() {
    return {
      'steps': steps,
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      steps: map['steps'] ?? 10000,
    );
  }
}
