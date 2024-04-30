import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/PhoneAuth/Signup.dart';
import 'package:to_do_app/Screens/Home.dart';

class CheckUserLogedIn extends StatelessWidget {
  CheckUserLogedIn({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const SignupUser();
          }
        }
      },
    );
  }
}
