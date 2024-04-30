import 'package:to_do_app/screens/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  Auth();
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  Future<bool> userExists(String phoneNumber) async {
    QuerySnapshot snapshot =
        await users.where("Phone", isEqualTo: phoneNumber).get();
    if (snapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber, BuildContext context,
      Function setData, Function loader) async {
    verificationCompleted(phoneAuthCredential) {
      showSnackBar(context, "Verification Compleated");
    }

    verificationFailed(error) {
      showSnackBar(context, "Verification Faild with error : ${error.code}");
      print("******************************************** ${error.toString()}");
      loader(false);
    }

    codeSent(verificationId, forceResendingToken) {
      showSnackBar(context, "Code Sent");
      setData(verificationId);
    }

    codeAutoRetrievalTimeout(verificationId) {
      showSnackBar(context, "Code Auto Retrival Timeout");
    }

    try {
      auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint(e.message);
      debugPrint(stackTrace.toString());
      showSnackBar(context, e.message.toString());
      loader(false);
    }
  }

  void signInWithPhoneNo(String verificationId, String smsCode,
      BuildContext context, String phoneNumber) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential user = await auth.signInWithCredential(credential);
      await userExists(phoneNumber)
          ? null
          : users
              .doc(user.user!.uid)
              .set({"Phone": phoneNumber, "date-time": DateTime.now()});
      showSnackBar(context, "User Logedin SuccessFully");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } on FirebaseAuthException catch (e, stackTrace) {
      showSnackBar(context, e.code);
      debugPrint(stackTrace.toString());
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackbar = SnackBar(
      content: Text(text),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
