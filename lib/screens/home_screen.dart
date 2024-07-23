import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                context.go('/profile');
              },
            ),
          ],
          title: Text('Quiz App',
              style: Theme.of(context).textTheme.displayLarge)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Welcome, John Doe!',
                style: Theme.of(context).textTheme.headlineSmall),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/quiz');
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          textStyle: const TextStyle(fontSize: 24),
                          backgroundColor: Colors.yellow),
                      child: const Text('New Quiz'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/pastquizzes');
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          textStyle: const TextStyle(fontSize: 24),
                          backgroundColor: Colors.yellow),
                      child: const Text('Past Quizzes'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
