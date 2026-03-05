class Question {
  final String questionText;
  final int correctAnswer;
  final List<int> options;
  final int? imageCount;
  final int? operand1;
  final int? operand2;

  // For comparison game
  final int? leftCount;
  final int? rightCount;
  final String? comparisonSymbol; // '<', '=', '>'

  // For sequence game
  final List<int>? sequence;

  // For math grid game
  final List<String>? gridLayout; // e.g., ['1', '+', '2', '=', '?']
  final List<int>? dragOptions; // Available numbers to drag

  Question({
    required this.questionText,
    required this.correctAnswer,
    required this.options,
    this.imageCount,
    this.operand1,
    this.operand2,
    this.leftCount,
    this.rightCount,
    this.comparisonSymbol,
    this.sequence,
    this.gridLayout,
    this.dragOptions,
  });
}
