import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/firebase_provider.dart';

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
        body: Consumer<FirebaseProvider>(
          builder: (context, firebaseProvider, _) {
            if (firebaseProvider.pastQuizzes.isEmpty) {
              return const Center(
                child: Text(
                  'No quizzes available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: firebaseProvider.pastQuizzes.length,
              itemBuilder: (context, index) {
                var quiz = firebaseProvider.pastQuizzes[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(
                        Icons.quiz,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        'Quiz on ${DateFormat('yMMMMd HH:mm:ss').format((DateTime.fromMicrosecondsSinceEpoch(quiz.timestamp)))}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      subtitle: Text(
                        'Score: ${quiz.finalscore}/${quiz.fullscore}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            ),
                      )),
                );
              },
            );
          },
        ));
  }
}
