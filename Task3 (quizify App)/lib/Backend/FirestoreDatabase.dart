import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizify/Models/Questions.dart';

CollectionReference questionCollection =
    FirebaseFirestore.instance.collection("Questions");

Future<void> addQuestions(List<Question> questions) async {
  for (int i = 0; i < questions.length; i++) {
    await questionCollection.add(questions[i].toMap());
  }
}
