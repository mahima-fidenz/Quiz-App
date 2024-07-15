import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/question_provider.dart';
import 'package:quiz_app/widgets/quiz_screen_widgets/keypad.dart';
import 'package:quiz_app/widgets/quiz_screen_widgets/question.dart';
import 'package:quiz_app/widgets/quiz_screen_widgets/quiz_header.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<StatefulWidget> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz', style: Theme.of(context).textTheme.displayLarge),
        backgroundColor: Colors.white,
      ),
      body: ChangeNotifierProvider(
        create: (_) => QuestionProvider(),
        child: const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(flex: 1, child: QuizHeaderWidget()),
                Expanded(flex: 3, child: QuestionWidget()),
                Expanded(flex: 4, child: KeypadWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
