import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quiz_app/common/constatnts.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/providers/firebase_provider.dart';

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
  int get currentQuestionCount => _questions.length;
  int get scorePerQuestion => _scorePerQuestion;
  int get currentScore =>
      _questions.where((q) => q.solution == q.solutionOfUser).length *
      scorePerQuestion;
  int get fullScore => _scorePerQuestion * _maxQuestionCount;

  QuestionProvider() {
    fetchNextQuestion();
  }

  void addCurrentQuestionToQuestions() {
    if (_currentQuestion != null) {
      _questions.add(_currentQuestion!);
    }
  }

  void finishQuiz(BuildContext context) {
    Provider.of<FirebaseProvider>(context, listen: false).addQuiz(Quiz(
        timestamp: DateTime.now().millisecondsSinceEpoch,
        finalscore: currentScore,
        fullscore: fullScore));
  }

  Future<void> fetchNextQuestion() async {
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
