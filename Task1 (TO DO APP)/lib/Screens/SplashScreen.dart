import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/Config/SQLHelper.dart';
import 'package:to_do_app/Globals/Variables.dart';
import 'package:to_do_app/Screens/GetUserDetails.dart';
import 'package:to_do_app/Screens/Home.dart';
import 'package:to_do_app/Screens/ListUsers.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

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
    if (await SQLHelper.isUserNull()) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const GetUser()),
          (route) => false);
    } else if (currentUser != {}) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const UsersAvailable()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetAnimator(
              atRestEffect: WidgetRestingEffects.size(
                  duration: const Duration(seconds: 10)),
              child: Image.asset(
                "Assets/Images/icon.png",
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            TextAnimator(
              incomingEffect: WidgetTransitionEffects(curve: Curves.easeIn),
              "To Do Application",
              style: GoogleFonts.styleScript(
                  fontSize: 45, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
