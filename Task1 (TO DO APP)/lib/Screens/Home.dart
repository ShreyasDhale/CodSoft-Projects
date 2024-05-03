import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/Config/NotificationHelper.dart';
import 'package:to_do_app/Config/SQLHelper.dart';
import 'package:to_do_app/Globals/Constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  int noOfTasks = 0;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    var name = await SQLHelper.getCurrentUser();
    var data = await SQLHelper.getTasks(null);
    int tasks = data.length;
    setState(() {
      user = name;
      noOfTasks = tasks;
    });
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        timeController.text =
            formatTimeOfDay(picked); // Set the selected date on the text field
      });
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('EEEE , d-MMMM-y')
            .format(picked)
            .toString(); // Set the selected date on the text field
      });
    }
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    DateTime dateTime = DateTime(1, 1, 1, timeOfDay.hour, timeOfDay.minute);
    String formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  DateTime formattedTimeToDateTime(String formattedTimeString, DateTime date) {
    DateTime dateTime = DateFormat.jm().parse(formattedTimeString);
    DateTime combinedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
    return combinedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome",
          style: headLineStyle.copyWith(color: Colors.grey, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: Colors.grey),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_on_outlined,
                color: Colors.grey,
              ))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                "Logout",
                style: titleStyle,
              ),
              onTap: () {
                SQLHelper.logout(user['id'], context);
              },
            )
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Hello ${user['name']}",
                    style: headLineStyle.copyWith(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "$noOfTasks tasks pending",
                    style: headLineStyle.copyWith(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showForm(context);
        },
        child: Text(
          "+",
          style: headLineStyle,
        ),
      ),
    );
  }

  Future<dynamic> showForm(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (builder) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Add Event",
                      style: headLineStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: eventController,
                    style: titleStyle,
                    decoration: const InputDecoration(
                        labelText: 'Add Event',
                        hintText: 'Today is My Interview',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                        )),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        suffixIcon: Icon(
                          Icons.task,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    readOnly: true,
                    controller: dateController,
                    onTap: () async {
                      selectDate(context);
                    },
                    style: titleStyle,
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      hintText:
                          DateFormat('EEEE , d-MMMM-y').format(DateTime.now()),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                      )),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      suffixIcon: const Icon(
                        Icons.calendar_month_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    readOnly: true,
                    onTap: () async {
                      selectTime(context);
                    },
                    keyboardType: TextInputType.datetime,
                    style: titleStyle,
                    controller: timeController,
                    decoration: InputDecoration(
                      labelText: 'Select Time(Optional)',
                      hintText: formatTimeOfDay(TimeOfDay.now()),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                      )),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      suffixIcon: const Icon(
                        Icons.alarm,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              // int id = await db.getLastNotificationId();
                              DateTime dateObject =
                                  DateFormat('EEEE , d-MMMM-y')
                                      .parse(dateController.text);
                              DateTime hr = formattedTimeToDateTime(
                                  timeController.text, dateObject);
                              Navigator.pop(context);
                              NotificationHelper.sendNotification(
                                  notId: 0,
                                  title: eventController.text,
                                  body: dateController.text,
                                  notificationDateTime: hr);
                              // db.createTask(
                              //     eventController.text.trim(),
                              //     dateController.text.trim(),
                              //     timeController.text.trim(),
                              //     context);
                            } on Exception catch (e) {
                              // db.showSnackBar(e.toString(), context);
                              print(e.toString());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width),
                              maximumSize: const Size.fromHeight(56),
                              shape: const BeveledRectangleBorder()),
                          child: Text(
                            "Schedule",
                            style: headLineStyle,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
  }
}
