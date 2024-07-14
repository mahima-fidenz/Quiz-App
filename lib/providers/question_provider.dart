import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/question.dart';

class QuestionProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _error = '';
  Question? _currentQuestion;

  bool get isLoading => _isLoading;
  String get error => _error;
  Question? get currentQuestion => _currentQuestion;

  QuestionProvider() {
    fetchQuestion();
  }

  Future<void> fetchQuestion() async {
    _isLoading = true;
    final response =
        await http.get(Uri.parse('https://marcconrad.com/uob/smile/api.php'));

    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body) as Map<String, dynamic>;
        _currentQuestion = Question.fromJson(json);
        _error = '';
      } else {
        throw Exception("Failed to load the question");
      }
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
