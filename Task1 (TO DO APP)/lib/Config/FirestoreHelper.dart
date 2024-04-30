import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/Globals/Constants.dart';

class FirestoreHelper {
  static getTasks() {}
  Future<void> createTask(
      String task, String date, String time, BuildContext context) async {
    int id = await getLastNotificationId();
    await tasks.add({
      "notId": ++id,
      "task": task,
      "date": date,
      "time": time,
      "created_on": DateTime.now().toString()
    });
    showSnackBar("Task Scheduled", context);
  }

  Future<int> getLastNotificationId() async {
    QuerySnapshot snapshot =
        await tasks.orderBy("notId", descending: true).get();
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot docSnap = snapshot.docs.first;
      Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
      return data['notId'];
    } else {
      return 1;
    }
  }

  void showSnackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
