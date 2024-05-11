import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// fonts

TextStyle style = GoogleFonts.poppins();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void showSuccess({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    showCloseIcon: true,
    backgroundColor: Colors.green.shade800,
    behavior: SnackBarBehavior.floating,
    elevation: 20,
    animation: const AlwaysStoppedAnimation(20),
  ));
}

void showFailure({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    showCloseIcon: true,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red.shade800,
    elevation: 20,
    animation: const AlwaysStoppedAnimation(20),
  ));
}
