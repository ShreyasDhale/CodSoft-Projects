import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:quizify/Backend/FirestoreDatabase.dart';
import 'package:quizify/Models/Questions.dart';

Future<void> readLines(String assetPath) async {
  try {
    String fileContents = await rootBundle.loadString(assetPath);

    var lines = LineSplitter.split(fileContents);
    List<Question> listQue = [];
    String que = "", A = "", B = "", C = "", D = "", answer = "";
    lines.forEach((line) {
      if (line.contains('Question:')) {
        que = line.split(":")[1].trim();
      }
      if (line.startsWith("A)")) {
        A = line.trim();
      }
      if (line.startsWith("B)")) {
        B = line.trim();
      }
      if (line.startsWith("C)")) {
        C = line.trim();
      }
      if (line.startsWith("D)")) {
        D = line.trim();
      }
      if (line.startsWith("Answer:")) {
        answer = line.split(":")[1].split(")")[0].trim();
        listQue.add(Question(
            que: que,
            A: A,
            B: B,
            C: C,
            D: D,
            answer: answer,
            type: "DART",
            subject: "Flutter Framework",
            level: "HARD"));
      }
    });
    await addQuestions(listQue);
    print(listQue[0].toMap());
    print('Questions Added to Firestore');
  } catch (e) {
    print("Error reading file: $e");
  }
}
