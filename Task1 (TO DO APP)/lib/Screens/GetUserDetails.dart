import 'package:flutter/material.dart';
import 'package:to_do_app/Config/SQLHelper.dart';
import 'package:to_do_app/Globals/Constants.dart';
import 'package:to_do_app/Globals/Variables.dart';
import 'package:to_do_app/Screens/Home.dart';
import 'package:to_do_app/Widgets/FormWidgets.dart';

class GetUser extends StatefulWidget {
  const GetUser({super.key});

  @override
  State<GetUser> createState() => _GetUserState();
}

class _GetUserState extends State<GetUser> {
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(
                Icons.play_circle_fill,
                color: Colors.black,
                size: 50,
              ),
              title: Row(
                children: [
                  Text(
                    "How it ",
                    style: titleStyle.copyWith(color: Colors.grey),
                  ),
                  Text(
                    "Works",
                    style: titleStyle.copyWith(color: Colors.orange),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "Assets/Images/HowitWorks.png",
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Manage Your Everyday task list",
                style: titleStyle.copyWith(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "Efficiently organize your daily activities with our comprehensive task management system",
              style: titleStyle.copyWith(fontSize: 17, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "Let's get started !!",
                  style: titleStyle.copyWith(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
            customTextfield(
                controller: nameController,
                keepBorder: false,
                leading: const Icon(Icons.person),
                label: "Enter Your Name"),
            const SizedBox(
              height: 20,
            ),
            customButton(
                text: "Continue",
                onTap: () async {
                  String name = nameController.text.trim();
                  await SQLHelper.createUser(name);
                  currentUser = await SQLHelper.getCurrentUser();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false);
                },
                bgColor: Colors.deepOrange)
          ],
        ),
      ),
    );
  }
}
