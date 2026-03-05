/// Model for structured math solution from Gemini API
class MathSolution {
  /// Extracted problem text from image
  final String problem;

  /// Type of math problem (arithmetic, algebra, geometry, calculus)
  final String problemType;

  /// Brief 2-3 sentence overview in simple Thai
  final String summary;

  /// Step-by-step solution breakdown
  final List<SolutionStep> steps;

  /// Clear final answer with units if applicable
  final String finalAnswer;

  /// Encouraging message for kids
  final String encouragement;

  MathSolution({
    required this.problem,
    required this.problemType,
    required this.summary,
    required this.steps,
    required this.finalAnswer,
    this.encouragement = 'เก่งมาก! 🌟',
  });

  /// Create MathSolution from JSON response
  factory MathSolution.fromJson(Map<String, dynamic> json) {
    return MathSolution(
      problem: json['problem'] as String? ?? '',
      problemType: json['problemType'] as String? ?? 'general',
      summary: json['summary'] as String? ?? '',
      steps: (json['steps'] as List<dynamic>?)
              ?.map((stepJson) => SolutionStep.fromJson(stepJson as Map<String, dynamic>))
              .toList() ??
          [],
      finalAnswer: json['finalAnswer'] as String? ?? '',
      encouragement: json['encouragement'] as String? ?? 'เก่งมาก! 🌟',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'problem': problem,
      'problemType': problemType,
      'summary': summary,
      'steps': steps.map((step) => step.toJson()).toList(),
      'finalAnswer': finalAnswer,
      'encouragement': encouragement,
    };
  }
}

/// Individual step in the solution
class SolutionStep {
  /// Short title for the step (e.g., "ขั้นที่ 1: แยกตัวแปร")
  final String title;

  /// Simple explanation in 1-2 sentences for children
  final String explanation;

  /// LaTeX formatted calculation (optional)
  final String? calculation;

  SolutionStep({
    required this.title,
    required this.explanation,
    this.calculation,
  });

  /// Create SolutionStep from JSON
  factory SolutionStep.fromJson(Map<String, dynamic> json) {
    return SolutionStep(
      title: json['title'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      calculation: json['calculation'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'explanation': explanation,
      if (calculation != null) 'calculation': calculation,
    };
  }
}

/// Problem type categories
class ProblemType {
  static const String arithmetic = 'arithmetic';
  static const String algebra = 'algebra';
  static const String geometry = 'geometry';
  static const String calculus = 'calculus';
  static const String general = 'general';

  /// Get display name in Thai
  static String getDisplayName(String type) {
    switch (type) {
      case arithmetic:
        return 'เลขคณิต';
      case algebra:
        return 'พีชคณิต';
      case geometry:
        return 'เรขาคณิต';
      case calculus:
        return 'แคลคูลัส';
      default:
        return 'ทั่วไป';
    }
  }

  /// Get emoji for problem type
  static String getEmoji(String type) {
    switch (type) {
      case arithmetic:
        return '🔢';
      case algebra:
        return '📐';
      case geometry:
        return '📏';
      case calculus:
        return '∫';
      default:
        return '📝';
    }
  }
}
