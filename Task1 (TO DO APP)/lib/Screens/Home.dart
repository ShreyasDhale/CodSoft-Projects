import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/Config/FirestoreHelper.dart';
import 'package:to_do_app/Config/NotificationHelper.dart';
import 'package:to_do_app/Globals/Constants.dart';
import 'package:to_do_app/PhoneAuth/Signup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userPhone = "";
  FirestoreHelper db = FirestoreHelper();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setCurrentPhone();
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

  void setCurrentPhone() async {
    if (currentUser != null) {
      DocumentSnapshot snap = await users.doc(currentUser!.uid).get();
      Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
      setState(() {
        userPhone = data["Phone"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome \n+91 $userPhone"),
        backgroundColor: Colors.deepPurple,
        titleTextStyle:
            titleStyle.copyWith(color: appBarForegroundColor, fontSize: 18),
        actionsIconTheme: IconThemeData(color: appBarForegroundColor),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupUser()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: tasks.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData && snapshot.data != null) {
                  print("Found Tasks");
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 10, left: 10),
                          child: ListTile(
                            tileColor: Colors.black.withOpacity(0.5),
                            title: Text(data['task'],
                                style:
                                    titleStyle.copyWith(color: Colors.white)),
                            subtitle: Text(
                                "date : " +
                                    data['date'] +
                                    "\nTime : " +
                                    data['time'],
                                style:
                                    titleStyle.copyWith(color: Colors.white70)),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  print("No Tasks!");
                  return Center(
                      child: Text(
                    "No Tasks",
                    style: headLineStyle.copyWith(color: Colors.black),
                  ));
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                print("Connection state is waiting!");
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              } else {
                print("Connection state is not active!");
                return Center(
                  child: Text("No data !!", style: headLineStyle),
                );
              }
            }),
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
                              int id = await db.getLastNotificationId();
                              DateTime dateObject =
                                  DateFormat('EEEE , d-MMMM-y')
                                      .parse(dateController.text);
                              DateTime hr = formattedTimeToDateTime(
                                  timeController.text, dateObject);
                              Navigator.pop(context);
                              NotificationHelper.sendNotification(
                                  notId: id,
                                  title: eventController.text,
                                  body: dateController.text,
                                  notificationDateTime: hr);
                              db.createTask(
                                  eventController.text.trim(),
                                  dateController.text.trim(),
                                  timeController.text.trim(),
                                  context);
                            } on Exception catch (e) {
                              db.showSnackBar(e.toString(), context);
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
