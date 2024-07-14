import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/common/theme.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/screens/login_screen.dart';
import 'package:quiz_app/screens/past_quizzes_screen.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

GoRouter router() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'quiz',
            builder: (context, state) => const QuizScreen(),
          ),
          GoRoute(
            path: 'pastquizzes',
            builder: (context, state) => const PastQuizzesScreen(),
          ),
        ],
      ),
    ],
  );
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quiz App',
      theme: appTheme,
      routerConfig: router(),
    );
  }
}
