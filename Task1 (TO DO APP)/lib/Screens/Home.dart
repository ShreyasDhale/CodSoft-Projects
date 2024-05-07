import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/Config/NotificationHelper.dart';
import 'package:to_do_app/Config/SQLHelper.dart';
import 'package:to_do_app/Globals/Constants.dart';
import 'package:to_do_app/Globals/Variables.dart';
import 'package:to_do_app/Models/Task.dart';
import 'package:to_do_app/Screens/Notifications.dart';
import 'package:to_do_app/Widgets/DropDownButton.dart';
import 'package:to_do_app/Widgets/EmptyList.dart';
import 'package:to_do_app/Widgets/FormWidgets.dart';
import 'package:to_do_app/Widgets/ShowPopUpMenu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int noOfTasks = 0;
  bool searchVisible = false;
  String selectedType = "Default";
  String selectedFilterType = "All";
  String repeat = "None (once)";
  String searchStr = "";
  List<String> repeteTypes = ["None (once)", "Daily", "Weakly", "Hourly"];
  List<String> items = [
    "Default",
    "Medical",
    "Sports",
    "Personal",
    "Professional"
  ];
  List<DropdownMenuItem<String>> dropItems = [
    DropdownMenuItem(
      value: "All",
      child: Text(
        "All",
        style: titleStyle,
      ),
    ),
    DropdownMenuItem(
      value: "Default",
      child: Text(
        "Default",
        style: titleStyle,
      ),
    ),
    DropdownMenuItem(
      value: "Medical",
      child: Text(
        "Medical",
        style: titleStyle,
      ),
    ),
    DropdownMenuItem(
      value: "Sports",
      child: Text(
        "Sports",
        style: titleStyle,
      ),
    ),
    DropdownMenuItem(
      value: "Personal",
      child: Text(
        "Personal",
        style: titleStyle,
      ),
    ),
    DropdownMenuItem(
      value: "Professional",
      child: Text(
        "Professional",
        style: titleStyle,
      ),
    ),
  ];
  List<Map<String, dynamic>> tasks = [];
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController eventController = TextEditingController();

  void setType(String value) {
    setState(() {
      selectedType = value;
    });
  }

  void setRepete(String value) {
    setState(() {
      repeat = value;
    });
  }

  @override
  void initState() {
    super.initState();
    NotificationHelper.initilize(refresh: refresh);
    refresh(null);
  }

  Future<void> refresh(String? type) async {
    var data = await SQLHelper.getTasks(type);
    setState(() {
      tasks = data;
      noOfTasks = tasks.length;
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
                onPressed: () {
                  setState(() {
                    searchVisible = !searchVisible;
                  });
                },
                icon: searchVisible
                    ? const Icon(
                        Icons.close,
                        color: Colors.grey,
                      )
                    : const Icon(
                        Icons.search,
                        color: Colors.grey,
                      )),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                },
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
                  SQLHelper.logout(currentUser['id'], context);
                  setState(() {
                    currentUser = {};
                  });
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
                      "Hello ${currentUser['name']}",
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
                const SizedBox(
                  height: 10,
                ),
                if (searchVisible)
                  // customTextfield(
                  //     controller: TextEditingController(),
                  //     label: "Search...",
                  //     onchanged: (value) {
                  //       setState(() {
                  //         searchStr = value;
                  //       });
                  //     },
                  //     borderRadius: 50,
                  //     leading: const Icon(
                  //       Icons.search,
                  //       color: Colors.grey,
                  //     )),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        searchStr = value;
                      });
                      print(searchStr);
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.blue,
                        labelText: "Search...",
                        labelStyle: titleStyle.copyWith(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(50))),
                  ),
                if (!searchVisible)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Filter Type",
                        style: titleStyle,
                      ),
                      DropdownButton(
                          value: selectedFilterType,
                          items: dropItems,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedFilterType = value;
                              });
                              if (selectedFilterType != "All") {
                                refresh(selectedFilterType);
                              } else {
                                refresh(null);
                              }
                            }
                          })
                    ],
                  ),
                if (noOfTasks == 0) const EmptyList(),
                if (noOfTasks != 0)
                  const SizedBox(
                    height: 10,
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: noOfTasks,
                    itemBuilder: (context, index) {
                      Task task = Task.fromMap(tasks[index]);
                      if (searchStr.isNotEmpty &&
                          task.task
                              .toLowerCase()
                              .contains(searchStr.toLowerCase())) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text(
                                  task.task,
                                  style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(task.ddate),
                                        Text(task.dtime),
                                      ],
                                    ),
                                    if (task.overdue == 1)
                                      Text(
                                        "Overdue",
                                        style: titleStyle.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2))),
                                        child: Text(
                                          task.type,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )),
                                  ],
                                ),
                                trailing: OptionsList(
                                  refresh: refresh,
                                  id: task.id,
                                  showForm: showForm,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      } else if (searchStr.isNotEmpty &&
                          !task.task
                              .toLowerCase()
                              .contains(searchStr.toLowerCase())) {
                        return const SizedBox();
                      } else {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text(
                                  task.task,
                                  style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(task.ddate),
                                        Text(task.dtime),
                                      ],
                                    ),
                                    if (task.overdue == 1)
                                      Text(
                                        "Overdue",
                                        style: titleStyle.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2))),
                                        child: Text(
                                          task.type,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )),
                                  ],
                                ),
                                trailing: OptionsList(
                                  refresh: refresh,
                                  id: task.id,
                                  showForm: showForm,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: customButton(
            text: "Add Task +",
            width: MediaQuery.of(context).size.width * 0.35,
            bgColor: Colors.deepOrange,
            onTap: () {
              showForm(context, null);
            }));
  }

  Future<dynamic> showForm(BuildContext context, int? taskId) async {
    if (taskId == null) {
      setState(() {
        selectedType = items.first;
        repeat = repeteTypes.first;
        eventController.text = "";
        dateController.text = "";
        timeController.text = "";
      });
    } else {
      final db = await SQLHelper.db();
      var data = await db.query("tasks", where: "id = ?", whereArgs: [taskId]);
      Task task = Task.fromMap(data.first);
      setState(() {
        selectedType = task.type;
        repeat = task.repeteType;
        eventController.text = task.task;
        dateController.text = task.ddate;
        timeController.text = task.dtime;
      });
    }

    return showModalBottomSheet(
        context: context,
        builder: (builder) => Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 10, left: 20, right: 20),
              child: ListView(
                children: [
                  Center(
                    child: Text(
                      "Add Event",
                      style: headLineStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                    height: 10,
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
                    height: 10,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Task Type",
                        style: titleStyle,
                      ),
                      DecoratedDropdownButton(
                        buttonType: "Type",
                        setRepete: setRepete,
                        setType: setType,
                        items: items,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Repeat",
                        style: titleStyle,
                      ),
                      DecoratedDropdownButton(
                        items: repeteTypes,
                        buttonType: "asdasd",
                        setRepete: setRepete,
                        setType: setType,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (taskId == null) {
                        try {
                          DateTime dateObject = DateFormat('EEEE , d-MMMM-y')
                              .parse(dateController.text);
                          DateTime hr = formattedTimeToDateTime(
                              timeController.text, dateObject);
                          Navigator.pop(context);

                          int id = await SQLHelper.createTask(
                              eventController.text.trim(),
                              dateController.text.trim(),
                              timeController.text.trim(),
                              selectedType,
                              repeat);
                          final db = await SQLHelper.db();
                          var task = await db.query("tasks",
                              where: "id = ?", limit: 1, whereArgs: [id]);
                          Task data = Task.fromMap(task.first);
                          if (data.repeteType == "None (once)") {
                            NotificationHelper.sendNotification(
                              notId: 0,
                              body: dateController.text,
                              notificationDateTime: hr,
                              title: eventController.text,
                              actionButtons: [
                                NotificationActionButton(
                                    key: "complete", label: "complete"),
                                NotificationActionButton(
                                    key: "overdue", label: "overdue"),
                                NotificationActionButton(
                                    actionType: ActionType.DismissAction,
                                    key: "dismiss",
                                    label: "cancel"),
                              ],
                              payload: {
                                "id": data.id.toString(),
                                "date": dateController.text.trim(),
                                "time": timeController.text.trim(),
                                "notId": data.notId.toString()
                              },
                            );
                          } else {
                            NotificationHelper.sendNotification(
                              notId: 0,
                              body: dateController.text,
                              title: eventController.text,
                              repeteType: data.repeteType,
                              notificationDateTime: hr,
                              actionButtons: [
                                NotificationActionButton(
                                    key: "complete", label: "complete"),
                                NotificationActionButton(
                                    key: "overdue", label: "overdue"),
                                NotificationActionButton(
                                    actionType: ActionType.DismissAction,
                                    key: "dismiss",
                                    label: "cancel"),
                              ],
                              payload: {
                                "id": data.id.toString(),
                                "date": dateController.text.trim(),
                                "time": timeController.text.trim(),
                                "notId": data.notId.toString()
                              },
                            );
                          }
                          refresh(null);
                          setState(() {
                            selectedFilterType = "All";
                          });
                        } on Exception catch (e) {
                          print(e.toString());
                        }
                      } else {
                        try {
                          DateTime dateObject = DateFormat('EEEE , d-MMMM-y')
                              .parse(dateController.text);
                          DateTime hr = formattedTimeToDateTime(
                              timeController.text, dateObject);
                          Navigator.pop(context);

                          await SQLHelper.updateTask(
                              taskId,
                              eventController.text.trim(),
                              dateController.text.trim(),
                              timeController.text.trim(),
                              selectedType,
                              repeat);
                          final db = await SQLHelper.db();
                          List<Map<String, dynamic>> data = await db.query(
                              "tasks",
                              where: "id = ?",
                              limit: 1,
                              whereArgs: [taskId]);
                          Task task = Task.fromMap(data.first);
                          int notId = task.notId;
                          await NotificationHelper.cancleNotification(notId);
                          if (task.repeteType == "None (once)") {
                            NotificationHelper.sendNotification(
                              notId: 0,
                              body: dateController.text,
                              notificationDateTime: hr,
                              title: eventController.text,
                              actionButtons: [
                                NotificationActionButton(
                                    key: "complete", label: "complete"),
                                NotificationActionButton(
                                    key: "overdue", label: "overdue"),
                                NotificationActionButton(
                                    actionType: ActionType.DismissAction,
                                    key: "dismiss",
                                    label: "cancel"),
                              ],
                              payload: {
                                "id": task.id.toString(),
                                "date": dateController.text.trim(),
                                "time": timeController.text.trim(),
                                "notId": task.notId.toString()
                              },
                            );
                          } else {
                            NotificationHelper.sendNotification(
                              notId: 0,
                              body: dateController.text,
                              title: eventController.text,
                              repeteType: task.repeteType,
                              notificationDateTime: hr,
                              actionButtons: [
                                NotificationActionButton(
                                    key: "complete", label: "complete"),
                                NotificationActionButton(
                                    key: "overdue", label: "overdue"),
                                NotificationActionButton(
                                    actionType: ActionType.DismissAction,
                                    key: "dismiss",
                                    label: "cancel"),
                              ],
                              payload: {
                                "id": task.id.toString(),
                                "date": dateController.text.trim(),
                                "time": timeController.text.trim(),
                                "notId": task.notId.toString()
                              },
                            );
                          }
                          refresh(null);
                          setState(() {
                            selectedFilterType = "All";
                          });
                        } on Exception catch (e) {
                          // db.showSnackBar(e.toString(), context);
                          print(e.toString());
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        fixedSize:
                            Size.fromWidth(MediaQuery.of(context).size.width),
                        maximumSize: const Size.fromHeight(56),
                        shape: const BeveledRectangleBorder()),
                    child: Text(
                      taskId != null ? "Update" : "Create",
                      style: headLineStyle,
                    ),
                  )
                ],
              ),
            ));
  }
}
