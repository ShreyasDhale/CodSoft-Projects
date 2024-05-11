import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizify/Globals/constants.dart';
import 'package:quizify/Globals/variables.dart';
import 'package:quizify/Widgets/FormWidgets.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "Assets/Images/bg.jpg",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Center(
                child: Text(
                  "\nQUIZIFY",
                  style: GoogleFonts.alike(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
              )),
              Container(
                margin: const EdgeInsets.all(20.0),
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back)),
                        Text(
                          "Forgot Password",
                          style: style.copyWith(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 50,
                        )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              customTextfield(
                                  controller: emailController,
                                  label: "Enter Email",
                                  leading: const Icon(Icons.email)),
                              const SizedBox(
                                height: 25,
                              ),
                              customButton(
                                  text: "Send Reset Request",
                                  onTap: () {
                                    if (emailController.text.isNotEmpty) {
                                      try {
                                        auth.sendPasswordResetEmail(
                                            email: emailController.text);
                                      } on FirebaseAuthException catch (e) {
                                        showFailure(
                                            context: context, message: e.code);
                                      } on Exception catch (ex) {
                                        showFailure(
                                            context: context,
                                            message: ex.toString());
                                      }
                                      showSuccess(
                                          context: context,
                                          message:
                                              "Request Sent to ${emailController.text}");
                                    } else {
                                      showFailure(
                                          context: context,
                                          message: "Plese Enter Email");
                                    }
                                  },
                                  bgColor: Colors.black,
                                  height: 60,
                                  borderRadius: 10),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
