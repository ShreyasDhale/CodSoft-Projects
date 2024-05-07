class Notifications {
  int id;
  int notId;
  String desc;
  String date;
  String time;

  Notifications(
      {required this.id,
      required this.notId,
      required this.desc,
      required this.date,
      required this.time});

  static Map<String, dynamic> toMap(Notifications not) {
    Map<String, dynamic> map = {};
    map["id"] = not.id;
    map["notId"] = not.id;
    map["desc"] = not.desc;
    map["ddate"] = not.date;
    map["dtime"] = not.time;
    return map;
  }

  static Notifications fromMap(Map<String, dynamic> map) {
    return Notifications(
        id: map["id"],
        notId: map["notId"],
        desc: map["desc"],
        date: map["ddate"],
        time: map["dtime"]);
  }
}
