import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/Config/CheckUserLogedIn.dart';

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

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 4));
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => CheckUserLogedIn()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "To Do Application",
          style: GoogleFonts.styleScript(
              fontSize: 45, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
