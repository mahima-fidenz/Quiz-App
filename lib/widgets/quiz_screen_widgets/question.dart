import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/question_provider.dart';

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
    var question = context.watch<QuestionProvider>();
    if (question.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (question.error.isNotEmpty) {
      return Center(child: Text(question.error));
    }
    return (question.currentQuestion?.imageUrl) != null
        ? Image.network(question.currentQuestion!.imageUrl)
        : const Text("Could not load the question");
  }
}
