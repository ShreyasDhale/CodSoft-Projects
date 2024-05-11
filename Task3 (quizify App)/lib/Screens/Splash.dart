import 'package:flutter/material.dart';
import 'package:quizify/Authantication/login.dart';
import 'package:quizify/Globals/variables.dart';
import 'package:quizify/Screens/HomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  void redirect() async {
    Future.delayed(const Duration(seconds: 4)).then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    (user != null) ? const HomePage() : const Login()),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "Assets/Images/splash.png",
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
    );
  }
}
