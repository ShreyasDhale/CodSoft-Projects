import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/Config/SQLHelper.dart';
import 'package:to_do_app/Globals/Constants.dart';
import 'package:to_do_app/Models/Notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => NotificationsState();
}

class NotificationsState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    setter();
  }

  Future<void> setter() async {
    setState(() {
      loading = true;
    });
    var data = await SQLHelper.getNotifications();
    setState(() {
      notifications = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Notifications\n${notifications.length} pending",
                style: titleStyle.copyWith(color: Colors.grey),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          Notifications not =
                              Notifications.fromMap(notifications[index]);
                          if (notifications.isNotEmpty) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  top: 10, right: 20, left: 20),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text(
                                  not.desc,
                                  style: titleStyle,
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      final db = await SQLHelper.db();
                                      db.delete("notify",
                                          where: "id = ?", whereArgs: [not.id]);
                                      setter();
                                    },
                                    icon: const Icon(Icons.delete)),
                                subtitle: Text("${not.date} \t ${not.time}"),
                                leading: const Icon(Icons.notifications),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Image.asset("Assets/Images/empty.png"),
                                    Text(
                                      "No Notifications !!",
                                      style: headLineStyle,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }))
              ],
            ),
          );
  }
}
