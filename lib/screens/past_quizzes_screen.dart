import 'package:flutter/material.dart';

class PastQuizzesScreen extends StatelessWidget {
  const PastQuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Past Quizzes',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: const SizedBox.expand(
        child: Center(
          child: Placeholder(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
