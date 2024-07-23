import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz.dart';

class FirebaseProvider extends ChangeNotifier {
  FirebaseProvider() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _pastQuizzesSubscription;
  List<Quiz> _pastQuizzes = [];
  List<Quiz> get pastQuizzes => _pastQuizzes;

  Future<void> init() async {
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _pastQuizzesSubscription = FirebaseFirestore.instance
            .collection('quizzes')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _pastQuizzes = [];
          for (final document in snapshot.docs) {
            _pastQuizzes.add(Quiz(
                timestamp: document.data()['timestamp'] as int,
                finalscore: document.data()['finalscore'] as int,
                fullscore: document.data()['fullscore'] as int));
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _pastQuizzes = [];
        _pastQuizzesSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> addQuiz(Quiz quiz) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('quizzes')
        .add(<String, dynamic>{
      'fullscore': quiz.fullscore,
      'timestamp': quiz.timestamp,
      'finalscore': quiz.finalscore,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
