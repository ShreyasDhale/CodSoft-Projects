import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizify/Authantication/login.dart';
import 'package:quizify/Globals/constants.dart';
import 'package:quizify/Globals/variables.dart';
import 'package:quizify/Screens/HomePage.dart';

class Auth {
  static Future<void> getCurrentUser(String email) async {
    await users.where("email", isEqualTo: email).get().then((value) {
      currentUser = value.docs.first.data() as Map<String, dynamic>;
    });
  }

  static Future<void> signup(String name, String email, String password,
      BuildContext context, Function loader) async {
    try {
      loader(true);
      await users.where("email", isEqualTo: email).get().then((value) async {
        if (value.docs.isNotEmpty) {
          showFailure(context: context, message: "User Already Exists");
        } else {
          await auth.createUserWithEmailAndPassword(
              email: email, password: password);
          await users.add({"name": name, "email": email});
          showSuccess(
              context: context, message: "Account created Successfully");
          loader(false);
        }
      });
    } on FirebaseAuthException catch (ex) {
      print(ex.code);
      showFailure(context: context, message: ex.code);
      loader(false);
    }
  }

  static Future<void> signin(String email, String password,
      BuildContext context, Function loader) async {
    try {
      loader(true);
      await auth.signInWithEmailAndPassword(email: email, password: password);
      user = auth.currentUser;
      await Auth.getCurrentUser(email);
      loader(false);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
      showSuccess(context: context, message: "Login Successfull");
    } on FirebaseAuthException catch (ex) {
      showFailure(context: context, message: ex.code);
      loader(false);
    }
  }

  static Future<void> signout(BuildContext context) async {
    await auth.signOut();
    user = null;
    currentUser = {};
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
  }
}
