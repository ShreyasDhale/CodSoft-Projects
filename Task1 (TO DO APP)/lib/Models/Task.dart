class Task {
  final int id;
  final String task;
  final String ddate;
  final String dtime;
  String type;
  String repeteType;
  int notId;
  int overdue;
  int fav;

  Task(
      {required this.id,
      required this.task,
      required this.ddate,
      required this.dtime,
      required this.type,
      this.notId = 0,
      this.overdue = 0,
      this.fav = 0,
      this.repeteType = "None(once)"});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'ddate': ddate,
      'dtime': dtime,
      'type': type,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      task: map['task'],
      ddate: map['ddate'],
      dtime: map['dtime'],
      notId: map['notId'],
      overdue: map['overdue'],
      fav: map['fev'],
      repeteType: map['repeteType'],
      type: map['type'],
    );
  }
}
