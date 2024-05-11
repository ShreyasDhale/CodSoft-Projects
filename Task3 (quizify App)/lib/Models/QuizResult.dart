class Result {
  final int marks;
  final int correct;
  final int wrong;
  final double percentage;
  final String grade;
  final String comment;
  final String level;
  final String name;
  final String email;
  final String subject;

  Result({
    required this.marks,
    required this.correct,
    required this.wrong,
    required this.percentage,
    required this.grade,
    required this.comment,
    required this.level,
    required this.name,
    required this.email,
    required this.subject,
  });

  factory Result.fromMap(Map<String, dynamic> data) {
    return Result(
        marks: data['marks'],
        correct: data['correct'],
        wrong: data['wrong'],
        percentage: data['percentage'],
        grade: data['grade'],
        comment: data['comment'],
        level: data['level'],
        name: data['name'],
        email: data['email'],
        subject: data['subject']);
  }

  // Object to Map converter
  Map<String, dynamic> toMap() {
    return {
      'marks': marks,
      'correct': correct,
      'wrong': wrong,
      'percentage': percentage,
      'grade': grade,
      'comment': comment,
      'level': level,
      'name': name,
      'email': email,
      'subject': subject,
    };
  }
}
