class Question {
  final String _imageUrl;
  final int _solution;

  int solutionOfUser = -1;
  String get imageUrl => _imageUrl;
  int get solution => _solution;

  Question({required String imageUrl, required int solution, int? maxDuration})
      : _solution = solution,
        _imageUrl = imageUrl;

  factory Question.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {"question": String imageUrl, "solution": int solution} =>
        Question(imageUrl: imageUrl, solution: solution),
      _ => throw const FormatException('Failed to load the question.'),
    };
  }
}
