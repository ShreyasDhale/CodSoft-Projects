import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizify/Authantication/Auth.dart';
import 'package:quizify/Globals/constants.dart';
import 'package:quizify/Widgets/FormWidgets.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<Signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool visiblity = false;
  bool loader = false;

  void load(bool isLoading) {
    setState(() {
      loader = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          "Student Signup",
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
                        child: ListView(
                          children: [
                            customTextfield(
                                controller: nameController,
                                label: "Enter Your Name",
                                leading: const Icon(Icons.person)),
                            const SizedBox(
                              height: 16,
                            ),
                            customTextfield(
                                controller: emailController,
                                label: "Enter Your Email",
                                leading: const Icon(Icons.email)),
                            const SizedBox(
                              height: 16,
                            ),
                            customPasswordfield(
                              controller: passwordController,
                              label: "Create Your Password",
                              leading: const Icon(Icons.password),
                              obsicure: visiblity,
                              trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      visiblity = !visiblity;
                                    });
                                  },
                                  icon: visiblity
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off)),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            customButton(
                                text: "Signup",
                                onTap: () {
                                  Auth.signup(
                                      nameController.text.trim(),
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                      context,
                                      load);
                                  setState(() {
                                    nameController.text = "";
                                    emailController.text = "";
                                    passwordController.text = "";
                                  });
                                },
                                loader: loader,
                                bgColor: Colors.black,
                                borderRadius: 10,
                                height: 50)
                          ],
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
