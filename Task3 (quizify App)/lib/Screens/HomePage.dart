import 'package:flutter/material.dart';
import 'package:quizify/Authantication/Auth.dart';
import 'package:quizify/Globals/constants.dart';
import 'package:quizify/Globals/variables.dart';
import 'package:quizify/Models/Quiz.dart';
import 'package:quizify/Widgets/FormWidgets.dart';
import 'package:quizify/Widgets/QuizTile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var searchController = TextEditingController();
  String searchStr = "";
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    users
        .where("email", isEqualTo: user!.email)
        .get()
        .then((value) => setState(() {
              currentUser = value.docs.first.data() as Map<String, dynamic>;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? customTextfield(
                keepBorder: false,
                controller: searchController,
                fillColor: Colors.transparent,
                label: "Search(General Knowledge)...",
                labelStyle: style.copyWith(color: Colors.grey, fontSize: 13),
                leading: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                onChanged: (value) {
                  setState(() {
                    searchStr = value;
                  });
                },
              )
            : Text(
                "Welcome",
                style: style.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
        iconTheme: const IconThemeData(color: Colors.grey, size: 30),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
              icon: !isSearching
                  ? const Icon(
                      Icons.search,
                    )
                  : const Icon(
                      Icons.close,
                    ))
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 70,
              ),
            ),
            Text(
              "User Details",
              style: style,
            ),
            const Divider(
              color: Colors.black,
              thickness: 3,
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(
                currentUser['email'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: style.copyWith(fontSize: 20),
              ),
              onTap: () => Auth.signout(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                currentUser['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: style.copyWith(fontSize: 20),
              ),
              onTap: () => Auth.signout(context),
            ),
            const Divider(
              color: Colors.black,
              thickness: 3,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                "Logout",
                style: style.copyWith(fontSize: 20),
              ),
              onTap: () => Auth.signout(context),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text(
                "   Hello ${currentUser['name']}",
                style:
                    style.copyWith(fontWeight: FontWeight.w900, fontSize: 30),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
                stream: quiz.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Quiz quizData = Quiz.fromMap(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);
                          String id = snapshot.data!.docs[index].id;
                          bool matchesSearch = searchStr.isNotEmpty &&
                              (quizData.subject
                                      .toLowerCase()
                                      .contains(searchStr.toLowerCase()) ||
                                  quizData.type
                                      .toLowerCase()
                                      .contains(searchStr.toLowerCase()));
                          if (matchesSearch) {
                            return QuizTile(
                              quizData: quizData,
                              quizId: id,
                            );
                          } else if (searchStr.isEmpty) {
                            return QuizTile(
                              quizData: quizData,
                              quizId: id,
                            );
                          } else if (searchStr.isNotEmpty &&
                              index == snapshot.data!.docs.length - 1) {
                            if (matchesSearch) {
                              return Container(); // No items found, so return an empty container
                            } else {
                              return const Center(
                                child: Text("No more items found"),
                              );
                            }
                          } else {
                            return Container();
                          }
                        });
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                      child: Text(
                        "No Quizes Found",
                        style: style.copyWith(fontSize: 25),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
