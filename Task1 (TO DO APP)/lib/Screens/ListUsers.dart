import 'package:flutter/material.dart';
import 'package:to_do_app/Config/SQLHelper.dart';
import 'package:to_do_app/Globals/Constants.dart';
import 'package:to_do_app/Screens/GetUserDetails.dart';

class UsersAvailable extends StatefulWidget {
  const UsersAvailable({super.key});

  @override
  State<UsersAvailable> createState() => _UsersAvailableState();
}

class _UsersAvailableState extends State<UsersAvailable> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    var data = await SQLHelper.getUsers();
    setState(() {
      users = data;
    });
    print(users);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Users",
          style: headLineStyle,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const GetUser()),
                    (route) => false);
              },
              icon: const Icon(
                Icons.add_outlined,
                color: Colors.grey,
                size: 40,
              ))
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              if (index.isEven) {
                if (index + 1 < users.length) {
                  return Row(
                    children: [
                      Expanded(
                          child: AVATAR(
                        name: users[index]['name'],
                        id: users[index]['id'],
                        refresh: () {
                          getUsers();
                        },
                      )),
                      Expanded(
                          child: AVATAR(
                        name: users[index + 1]['name'],
                        id: users[index + 1]['id'],
                        refresh: () {
                          getUsers();
                        },
                      )),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                          child: AVATAR(
                        name: users[index]['name'],
                        id: users[index]['id'],
                        refresh: () {
                          getUsers();
                        },
                      )),
                    ],
                  );
                }
              } else {
                return const SizedBox.shrink();
              }
            }),
      ),
    );
  }
}

List<Color> colors = [
  Colors.red,
  Colors.blue,
  Colors.deepPurple,
  Colors.yellow,
  Colors.green,
];

List<int> shuffledIndices = [];

int getIndex(int max) {
  if (shuffledIndices.isEmpty) {
    shuffledIndices = List<int>.generate(max, (index) => index);
    shuffledIndices.shuffle();
  }
  return shuffledIndices.removeLast();
}

class AVATAR extends StatelessWidget {
  final String name;
  final int id;
  final Function refresh;
  const AVATAR(
      {super.key, required this.name, required this.id, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              SQLHelper.login(id, context);
            },
            child: CircleAvatar(
              backgroundColor: colors[getIndex(colors.length)],
              radius: 40,
              child: Text(
                name.characters.first.toUpperCase(),
                style: titleStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: titleStyle,
              ),
              IconButton(
                  onPressed: () {
                    SQLHelper.deleteUser(id);
                    refresh();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
