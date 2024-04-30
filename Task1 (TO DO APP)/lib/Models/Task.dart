class Task {
  final int id;
  final String task;
  final String ddate;
  final String dtime;
  String type;
  final int notId;
  final int overdue;
  final int fav;

  Task({
    required this.id,
    required this.task,
    required this.ddate,
    required this.dtime,
    this.type = "Default[All]",
    required this.notId,
    required this.overdue,
    required this.fav,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'ddate': ddate,
      'dtime': dtime,
      'type': type,
      'notId': notId,
      'overdue': overdue,
      'fav': fav,
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
      fav: map['fav'],
    );
  }
}
