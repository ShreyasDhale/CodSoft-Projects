import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quizify/Globals/constants.dart';

class QuizTimer extends StatefulWidget {
  const QuizTimer({super.key, required this.submit, required this.context});
  final void Function(bool) submit;
  final BuildContext context;

  @override
  State<QuizTimer> createState() => Quiz_TimerState();
}

class Quiz_TimerState extends State<QuizTimer> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return TimerCountdown(
        format: CountDownTimerFormat.minutesSeconds,
        timeTextStyle:
            style.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        colonsTextStyle:
            style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        descriptionTextStyle: style.copyWith(color: Colors.white),
        onEnd: () {
          widget.submit(true);
        },
        onTick: (remainingTime) {
          if (remainingTime.inSeconds == 60) {
            Fluttertoast.showToast(
                msg: "Last 1 minute left Be Quick",
                textColor: Colors.white,
                fontSize: 20,
                backgroundColor: Colors.red);
          }
        },
        endTime: now.add(const Duration(minutes: 5)));
  }
}
