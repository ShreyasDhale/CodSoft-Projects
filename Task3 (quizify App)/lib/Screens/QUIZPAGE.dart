import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizify/Globals/constants.dart';
import 'package:quizify/Globals/variables.dart';
import 'package:quizify/Models/Questions.dart';
import 'package:quizify/Models/Quiz.dart';
import 'package:quizify/Models/QuizResult.dart';
import 'package:quizify/Screens/Result.dart';
import 'package:quizify/Widgets/ConfirmDialog.dart';
import 'package:quizify/Widgets/FormWidgets.dart';
import 'package:quizify/Widgets/Timer.dart';

class QuizPage extends StatefulWidget {
  const QuizPage(
      {super.key,
      required this.questions,
      required this.quizData,
      required this.userId,
      required this.quizId});
  final List<Question> questions;
  final Quiz quizData;
  final String userId;
  final String quizId;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with WidgetsBindingObserver {
  int currentIndex = 0;
  String selectedOption = "";
  List<String?> choices = [];
  List<String?> answers = [];
  List<Question> quizQuestions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.questions.forEach((element) {
      quizQuestions.add(element);
      choices.add(null);
      answers.add(element.answer);
    });
    print(choices);
    print(answers);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      submit(true);
      Future.delayed(const Duration(seconds: 1)).then((value) {
        showFailure(
            context: navigatorKey.currentState!.context,
            message:
                "You cant switch screens during the quiz so quiz is auto submitted");
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
                title: Text(
                  "${widget.quizData.type} QUIZ",
                  style: style.copyWith(fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height * 0.7,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "${currentIndex + 1}/${quizQuestions.length}",
                                    style: style.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white60),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Q.${currentIndex + 1}  ",
                                        style: style.copyWith(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Text(
                                          quizQuestions[currentIndex].que,
                                          style: style.copyWith(
                                              fontSize: 17,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.transparent)),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          choices[currentIndex] = "A";
                                        });
                                      },
                                      child: ListTile(
                                        title: Text(
                                          quizQuestions[currentIndex].A,
                                          style: style.copyWith(fontSize: 15),
                                        ),
                                        leading: Radio(
                                          value: "A",
                                          groupValue: choices[currentIndex],
                                          onChanged: (value) {
                                            print(value);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.transparent)),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          choices[currentIndex] = "B";
                                        });
                                      },
                                      child: ListTile(
                                        title: Text(
                                          quizQuestions[currentIndex].B,
                                          style: style.copyWith(fontSize: 15),
                                        ),
                                        leading: Radio(
                                          value: "B",
                                          groupValue: choices[currentIndex],
                                          onChanged: (value) {
                                            setState(() {
                                              choices[currentIndex] = value;
                                            });
                                            print(value);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.transparent)),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          choices[currentIndex] = "C";
                                        });
                                      },
                                      child: ListTile(
                                        title: Text(
                                          quizQuestions[currentIndex].C,
                                          style: style.copyWith(fontSize: 15),
                                        ),
                                        leading: Radio(
                                          value: "C",
                                          groupValue: choices[currentIndex],
                                          onChanged: (value) {
                                            setState(() {
                                              choices[currentIndex] = value;
                                            });
                                            print(value);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.transparent)),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          choices[currentIndex] = "D";
                                        });
                                      },
                                      child: ListTile(
                                        title: Text(
                                          quizQuestions[currentIndex].D,
                                          style: style.copyWith(fontSize: 15),
                                        ),
                                        leading: Radio(
                                          value: "D",
                                          groupValue: choices[currentIndex],
                                          onChanged: (value) {
                                            setState(() {
                                              choices[currentIndex] = value;
                                            });
                                            print(value);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0, left: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      currentIndex != 0
                                          ? customButton(
                                              text: "<- Prev",
                                              width: 130,
                                              height: 40,
                                              borderRadius: 5,
                                              bgColor: Colors.purple,
                                              onTap: () {
                                                setState(() {
                                                  currentIndex--;
                                                });
                                              })
                                          : const SizedBox(),
                                      currentIndex != quizQuestions.length - 1
                                          ? customButton(
                                              text: "Save Next ->",
                                              width: 130,
                                              height: 40,
                                              borderRadius: 5,
                                              bgColor: Colors.green.shade900,
                                              onTap: () {
                                                setState(() {
                                                  currentIndex++;
                                                });
                                              })
                                          : customButton(
                                              text: "SUBMIT",
                                              width: 130,
                                              height: 40,
                                              bgColor: Colors.orange,
                                              borderRadius: 5,
                                              onTap: () => submit(
                                                    false,
                                                  )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            Text(
                              "* All Questions are Compulsory *",
                              style: style.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.deepOrange.shade800,
                          Colors.deepOrange.shade400
                        ]),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Text(
                          "Time Left",
                          style: style.copyWith(color: Colors.white),
                        ),
                        QuizTimer(
                          submit: submit,
                          context: context,
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> submit(bool isAutoSubmit) async {
    int marks = 0;
    int correct = 0;
    int wrong = 0;
    int length = quizQuestions.length;
    double percentage = 0;
    for (int i = 0; i < length; i++) {
      if (answers[i] == choices[i]) {
        marks = marks + 2;
        correct++;
      } else {
        wrong++;
      }
    }
    percentage = correct / length * 100;
    Map<String, dynamic> data = getComment(percentage, widget.quizData.subject);
    Result result = Result(
        marks: marks,
        correct: correct,
        wrong: wrong,
        percentage: percentage,
        grade: data['grade'],
        comment: data['msg'],
        level: widget.questions.first.level,
        name: currentUser['name'],
        email: currentUser['email'],
        subject: widget.quizData.subject);
    print(result.toMap());
    print(widget.questions[2].toMap());
    if (isAutoSubmit) {
      await saveResult(result, widget.quizId);
    } else {
      if (choices.contains(null)) {
        showFailure(
            context: navigatorKey.currentState!.context,
            message: "Please attempt all questions");
      } else {
        showConfirm(
            context: navigatorKey.currentState!.context,
            confirmation: "Are You Sure you want to submit the Quiz",
            buttonText: "Submit",
            onConfirm: () async {
              await saveResult(result, widget.quizId);
            });
      }
    }
  }

  Future<void> saveResult(Result result, String quizId) async {
    await quiz.doc(quizId).collection("Result").add(result.toMap());
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (builder) => ResultPage(
            result: result,
            quizId: quizId,
          ),
        ),
        (route) => false);
  }
}
