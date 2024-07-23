import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/common/constatnts.dart';
import 'package:quiz_app/providers/question_provider.dart';
import 'package:quiz_app/widgets/quiz_screen_widgets/timer.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    var questionProvider = context.watch<QuestionProvider>();
    if (questionProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (questionProvider.error.isNotEmpty) {
      return Center(child: Text(questionProvider.error));
    }
    return (questionProvider.currentQuestion?.imageUrl) != null
        ? Column(
            children: [
              TimerWidget(
                  durationMiliseconds: AppConstants.quizDuration,
                  onTimerFinish: () {
                    questionProvider.finishQuiz(context);
                    context.go('/quizresult', extra: {
                      'userScore': questionProvider.currentScore,
                      'fullScore': questionProvider.fullScore
                    });
                  }),
              Image.network(questionProvider.currentQuestion!.imageUrl),
            ],
          )
        : const Text("Could not load the question");
  }
}
