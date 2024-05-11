import 'package:flutter/material.dart';
import 'package:quizify/Globals/constants.dart';
import 'package:quizify/Globals/variables.dart';
import 'package:quizify/Models/Quiz.dart';
import 'package:quizify/Screens/LeaderBoard.dart';
import 'package:quizify/Screens/QuizOptions.dart';
import 'package:quizify/Widgets/FormWidgets.dart';

class QuizTile extends StatelessWidget {
  const QuizTile({
    super.key,
    required this.quizData,
    required this.quizId,
  });
  final String quizId;
  final Quiz quizData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.blue.shade700,
            gradient: const LinearGradient(
                colors: [Colors.purple, Colors.lightBlue],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: ListTile(
          title: Text(
            quizData.subject,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 7,
              ),
              Container(
                color: Colors.white,
                height: 1,
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                "Questions ${quizData.questions}",
                style: style.copyWith(color: Colors.white),
              ),
              Text(
                "Levels EASY,NORMAL,HARD",
                style: style.copyWith(color: Colors.white),
              ),
              Row(
                children: [
                  Text(
                    "Abbrivations : ",
                    style: style.copyWith(color: Colors.white),
                  ),
                  Text(
                    quizData.type,
                    style: style.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Container(
                color: Colors.white,
                height: 1,
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: customButton(
                        text: "Leaderboard",
                        leading: const Row(
                          children: [
                            Icon(Icons.leaderboard),
                            SizedBox(
                              width: 1,
                            )
                          ],
                        ),
                        height: 40,
                        borderRadius: 10,
                        bgColor: Colors.green.shade800,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => LeaderBoard(
                                        quizId: quizId,
                                      )));
                          print(currentUser);
                        }),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: customButton(
                        text: "Attempt",
                        height: 40,
                        borderRadius: 10,
                        bgColor: Colors.deepOrange,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) =>
                                      QuizOptions(quizData: quizData)));
                          print(currentUser);
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
