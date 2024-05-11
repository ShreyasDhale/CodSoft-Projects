import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

CollectionReference users = FirebaseFirestore.instance.collection("Users");
CollectionReference quiz = FirebaseFirestore.instance.collection("Quiz");
CollectionReference questions =
    FirebaseFirestore.instance.collection("Questions");

FirebaseAuth auth = FirebaseAuth.instance;

User? user = auth.currentUser;

Map<String, dynamic> currentUser = {};

Map<String, String> getComment(double percentage, String subject) {
  if (percentage < 35) {
    return {
      "msg": "You Failed and Need to Improve yourself in $subject",
      "grade": "F"
    };
  } else if (percentage < 50 && percentage >= 35) {
    return {"msg": "You just passed. You need to improve", "grade": "C"};
  } else if (percentage < 80 && percentage >= 50) {
    return {"msg": "You Are pritty good in $subject", "grade": "B"};
  } else if (percentage < 90 && percentage >= 80) {
    return {"msg": "You Are Excellent in This $subject", "grade": "A"};
  } else if (percentage < 100 && percentage >= 90) {
    return {"msg": "You Are nearly perfect in $subject", "grade": "A+"};
  } else {
    return {"msg": "You Are Absolutely perfect in $subject!!", "grade": "O"};
  }
}
