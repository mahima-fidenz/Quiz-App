import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/common/constatnts.dart';
import 'package:quiz_app/models/question.dart';

class QuestionProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _error = '';
  Question? _currentQuestion;
  final List<Question> _questions = [];
  static const int _maxQuestionCount = 5;
  static const int _scorePerQuestion = 20;

  bool get isLoading => _isLoading;
  String get error => _error;
  Question? get currentQuestion => _currentQuestion;
  List<Question> get questions => _questions;
  int get maxQuestionCount => _maxQuestionCount;
  int get scorePerQuestion => _scorePerQuestion;
  int get currentScore =>
      _questions.where((q) => q.solution == q.solutionOfUser).length *
      scorePerQuestion;
  int get fullScore => _scorePerQuestion * _maxQuestionCount;

  QuestionProvider() {
    fetchNextQuestion();
  }

  void finishQuiz() {}

  Future<void> fetchNextQuestion({Function? onFinish}) async {
    if (_currentQuestion != null) {
      _questions.add(_currentQuestion!);
    }
    if (maxQuestionCount == questions.length) {
      if (onFinish != null) {
        onFinish();
      }
      finishQuiz();
      return;
    }
    _isLoading = true;
    final response = await http.get(Uri.parse(AppConstants.questionFetinchApi));

    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body) as Map<String, dynamic>;
        _currentQuestion = Question.fromJson(json);
        _error = '';
        notifyListeners();
      } else {
        notifyListeners();
        throw Exception("Failed to load the question");
      }
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }
}
