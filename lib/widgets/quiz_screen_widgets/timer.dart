import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final int durationMiliseconds;
  final Function onTimerFinish;

  const TimerWidget(
      {super.key,
      required this.durationMiliseconds,
      required this.onTimerFinish});

  @override
  State<StatefulWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> with WidgetsBindingObserver {
  late int _milisecondsRemaining;
  late double _barWidth;
  int durationMiliseconds = 17;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _milisecondsRemaining = widget.durationMiliseconds;
    _barWidth = 1.0;
    startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      startTimer();
    }
  }

  void startTimer() {
    _timer =
        Timer.periodic(Duration(milliseconds: durationMiliseconds), (timer) {
      setState(() {
        if (_milisecondsRemaining > 0) {
          _milisecondsRemaining -= durationMiliseconds;
          _barWidth = _milisecondsRemaining <= 0
              ? 0
              : _milisecondsRemaining / widget.durationMiliseconds;
        } else {
          widget.onTimerFinish();
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 30.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: Colors.black,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _barWidth,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.yellow,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    _milisecondsRemaining <= 0
                        ? "finished"
                        : ("${(_milisecondsRemaining / 1000).toStringAsFixed(0)}s left"),
                    style: TextStyle(
                      color: _milisecondsRemaining <= 0
                          ? Colors.white
                          : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(
                  Icons.timer_sharp,
                  color: Colors.white,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
