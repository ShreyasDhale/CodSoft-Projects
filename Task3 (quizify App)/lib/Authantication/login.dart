import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizify/Authantication/Auth.dart';
import 'package:quizify/Authantication/forgotPassword.dart';
import 'package:quizify/Authantication/signup.dart';
import 'package:quizify/Globals/constants.dart';
import 'package:quizify/Widgets/FormWidgets.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool visible = false;
  bool loader = false;

  void load(bool isLoading) {
    if (mounted) {
      setState(() {
        loader = isLoading;
      });
    }
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
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    Text(
                      "Login",
                      style: style.copyWith(fontSize: 23),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView(
                            children: [
                              customTextfield(
                                leading: const Icon(Icons.email),
                                controller: _emailController,
                                label: "Enter Email",
                              ),
                              const SizedBox(height: 16.0),
                              customPasswordfield(
                                leading: const Icon(Icons.password),
                                obsicure: visible,
                                trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        visible = !visible;
                                      });
                                    },
                                    icon: visible
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off)),
                                controller: _passwordController,
                                label: "Enter Pass Key Provided",
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const ForgotPassword()))),
                                    child: Text(
                                      'Forgot Password ?',
                                      style: style.copyWith(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25.0),
                              customButton(
                                onTap: () {
                                  Auth.signin(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                      context,
                                      load);
                                },
                                loader: loader,
                                borderRadius: 10,
                                height: 50,
                                bgColor: Colors.black,
                                text: 'Login',
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const Signup()))),
                                    child: Text(
                                      'Sign up ?',
                                      style: style.copyWith(fontSize: 20),
                                    ),
                                  ),
                                ],
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
