import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

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

  void onSubmit() {}

  Widget buildButton(String value) {
    return SizedBox.expand(
      child: ElevatedButton(
        onPressed: () => onButtonClick(value),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: input == value ? Colors.yellow : Colors.grey[300]),
        child: Text(value, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: input.isNotEmpty ? onSubmit : null,
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
