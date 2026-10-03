class QuizQuestion {
  final int number;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.number,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}
