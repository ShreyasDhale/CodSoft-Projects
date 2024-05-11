import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizify/Globals/constants.dart';
import 'package:quizify/Globals/variables.dart';
import 'package:quizify/Models/Questions.dart';
import 'package:quizify/Models/Quiz.dart';
import 'package:quizify/Screens/QUIZPAGE.dart';
import 'package:quizify/Widgets/FormWidgets.dart';

class QuizOptions extends StatefulWidget {
  const QuizOptions({super.key, required this.quizData});
  final Quiz quizData;

  @override
  State<QuizOptions> createState() => _QuizOptionsState();
}

class _QuizOptionsState extends State<QuizOptions> {
  String selectedValue = "EASY";
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "Assets/Images/bg.jpg",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                title: Text(
                  "${widget.quizData.subject} Quiz",
                  style: style.copyWith(fontSize: 20),
                ),
                centerTitle: true,
              ),
              Image.asset(
                "Assets/Images/quiz.png",
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.3,
                fit: BoxFit.cover,
              ),
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Difficulty level",
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<String>(
                        value: selectedValue,
                        iconEnabledColor: Colors.white,
                        iconDisabledColor: Colors.white70,
                        style: style.copyWith(),
                        dropdownColor: Colors.black.withOpacity(0.5),
                        underline: Container(
                          height: 1,
                          color: Colors.transparent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        items: <String>['EASY', 'NORMAL', 'HARD']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: style,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.5)),
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "* NOTE *",
                      style: style.copyWith(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 1,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "*",
                          style: style.copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "Your Responce will be recorder at your name",
                            style: style.copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "*",
                          style: style.copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "You Will get 5 minutes to complete this quiz",
                            style: style.copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "*",
                          style: style.copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "You Cant Cheat in this quiz if you change screen of the quiz your quiz will be auto submitted",
                            style: style.copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "*",
                          style: style.copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "Result will be displayed immidiatly after submitting quiz",
                            style: style.copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 1,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    customButton(
                        text: "Start Quiz Now",
                        loader: loader,
                        onTap: getData,
                        height: 40,
                        borderRadius: 5,
                        bgColor: Colors.deepOrange,
                        width: MediaQuery.of(context).size.width * 0.7),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getData() async {
    setState(() {
      loader = true;
    });
    List<Question> quizQuestions = await questions
        .where("type", isEqualTo: widget.quizData.type)
        .where("level", isEqualTo: selectedValue)
        .limit(20)
        .get()
        .then((value) {
      List<Question> quizQuestions = [];
      value.docs.forEach((doc) {
        Map<String, dynamic> que = doc.data() as Map<String, dynamic>;
        quizQuestions.add(Question.fromMap(que));
      });
      return quizQuestions;
    });
    String userId =
        await users.where("email", isEqualTo: user!.email).get().then((value) {
      return value.docs.first.id;
    });
    String quizId = await quiz
        .where("subject", isEqualTo: widget.quizData.subject)
        .get()
        .then((value) {
      return value.docs.first.id;
    });
    setState(() {
      loader = false;
    });

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (builder) => QuizPage(
                  questions: quizQuestions,
                  quizData: widget.quizData,
                  userId: userId,
                  quizId: quizId,
                )),
        (route) => false);
  }
}
