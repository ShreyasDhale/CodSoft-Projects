import 'package:flutter/material.dart';
import 'package:quizify/Globals/constants.dart';
import 'package:quizify/Globals/variables.dart';
import 'package:quizify/Models/Quiz.dart';
import 'package:quizify/Models/QuizResult.dart';
import 'package:quizify/Screens/HomePage.dart';
import 'package:quizify/Widgets/FormWidgets.dart';

class ResultPage extends StatefulWidget {
  final Result result;
  final String quizId;

  const ResultPage({super.key, required this.result, required this.quizId});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Map<String, dynamic> userData = {};
  Quiz? quizData;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      loading = true;
    });
    var data = await quiz.doc(widget.quizId).get().then((value) {
      return value.data() as Map<String, dynamic>;
    });
    setState(() {
      quizData = Quiz.fromMap(data);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentName = currentUser['name'];
    const totalMarks = 40;
    final obtainedMarks = widget.result.marks;
    final percentage = widget.result.percentage;
    final grade = widget.result.grade;
    final wrongChoices = widget.result.wrong;
    final correctChoices = widget.result.correct;
    final status = widget.result.grade.toLowerCase() == "f" ? "FAIL" : "PASS";

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 40,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: $studentName',
                            style: style.copyWith(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "R",
                            style: style.copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "E",
                            style: style.copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "S",
                            style: style.copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "U",
                            style: style.copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "L",
                            style: style.copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "T",
                            style: style.copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black)),
                      child: Text(
                        'Subject: ${quizData!.subject}',
                        style: style.copyWith(fontSize: 16),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: Text(
                              'Total Marks: $totalMarks',
                              style: style.copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: Text(
                              'Level: ${widget.result.level}',
                              style: style.copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black)),
                      child: Text(
                        'Obtained Marks: ${obtainedMarks.toStringAsFixed(2)}',
                        style: style.copyWith(fontSize: 16),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black)),
                      child: Text(
                        'Percentage: ${percentage.toStringAsFixed(2)}%',
                        style: style.copyWith(fontSize: 16),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Grade : ',
                                      style: style.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      grade,
                                      style: style.copyWith(
                                          fontSize: 16,
                                          color: (grade == "F")
                                              ? Colors.red
                                              : Colors.black,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: Row(
                              children: [
                                Text(
                                  "Status : ",
                                  style: style.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  status,
                                  style: style.copyWith(
                                      fontSize: 16,
                                      color: (status.toLowerCase() == "pass")
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Your Choices",
                          style: style.copyWith(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: Text(
                              'Correct : $correctChoices',
                              style: style.copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: Text(
                              'Wrong : $wrongChoices',
                              style: style.copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remark : ',
                            style: style.copyWith(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              widget.result.comment,
                              style: style,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            customButton(
                text: "Return to Home",
                leading: const Row(
                  children: [
                    Icon(Icons.home_filled),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false);
                },
                borderRadius: 1,
                bgColor: Colors.orangeAccent)
          ],
        ),
      ),
    );
  }
}
