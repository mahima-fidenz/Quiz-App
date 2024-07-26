import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/common/route_constants.dart';
import 'package:quiz_app/common/styles.dart';
import 'package:quiz_app/providers/question_provider.dart';

class KeypadWidget extends StatefulWidget {
  const KeypadWidget({super.key});

  @override
  State<StatefulWidget> createState() => _KeypadWidgetState();
}

class _KeypadWidgetState extends State<KeypadWidget> {
  String input = '';

  void onButtonClick(String value) {
    setState(() {
      input = value;
    });
  }

  Widget buildButton(String value) {
    return SizedBox.expand(
      child: ElevatedButton(
        onPressed: () => onButtonClick(value),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: input == value
                ? CommonStyles.yellowButtonBackground
                : Colors.grey[300]),
        child: Text(value, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var questionProvider = context.watch<QuestionProvider>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutGrid(
        areas: '''
            one two three
            four five six
            seven eight nine
            zero submit submit
          ''',
        columnSizes: [3.fr, 3.fr, 3.fr],
        rowSizes: [2.fr, 2.fr, 2.fr, 2.fr],
        columnGap: 10,
        rowGap: 10,
        children: [
          buildButton('1').inGridArea('one'),
          buildButton('2').inGridArea('two'),
          buildButton('3').inGridArea('three'),
          buildButton('4').inGridArea('four'),
          buildButton('5').inGridArea('five'),
          buildButton('6').inGridArea('six'),
          buildButton('7').inGridArea('seven'),
          buildButton('8').inGridArea('eight'),
          buildButton('9').inGridArea('nine'),
          buildButton('0').inGridArea('zero'),
          SizedBox.expand(
              child: ElevatedButton(
            onPressed: input.isNotEmpty
                ? () {
                    questionProvider.currentQuestion?.solutionOfUser =
                        int.parse(input);
                    if (questionProvider.currentQuestion?.solution.toString() ==
                        input) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(milliseconds: 400),
                          content: Text('Correct Answer!')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(milliseconds: 400),
                          content: Text(
                              'Your Answer: $input. Correct Answer: ${questionProvider.currentQuestion?.solution.toString()}')));
                    }
                    questionProvider.addCurrentQuestionToQuestions();
                    if (questionProvider.maxQuestionCount ==
                        questionProvider.currentQuestionCount) {
                      questionProvider.finishQuiz(context);
                      context.go(RouteConstants.quizResultPath, extra: {
                        'userScore': questionProvider.currentScore,
                        'fullScore': questionProvider.fullScore
                      });
                    } else {
                      questionProvider.fetchNextQuestion();
                    }
                    input = '';
                  }
                : null,
            style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.blue[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.blue[400]),
            child: Expanded(
                child: Text('Submit',
                    style: TextStyle(
                        fontSize: 32,
                        color: (input.isNotEmpty
                            ? Colors.black87
                            : Colors.black38)))),
          )).inGridArea('submit')
        ],
      ),
    );
  }
}
