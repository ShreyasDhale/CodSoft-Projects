class Question {
  final String que;
  final String A;
  final String B;
  final String C;
  final String D;
  final String answer;
  final String type;
  final String level;
  final String subject;

  Question({
    required this.que,
    required this.A,
    required this.B,
    required this.C,
    required this.D,
    required this.answer,
    required this.type,
    required this.level,
    required this.subject,
  });

  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      que: data['que'],
      A: data['A'],
      B: data['B'],
      C: data['C'],
      D: data['D'],
      answer: data['answer'],
      type: data['type'],
      subject: data['subject'],
      level: data['level'],
    );
  }

  // Object to Map converter
  Map<String, dynamic> toMap() {
    return {
      'que': que,
      'A': A,
      'B': B,
      'C': C,
      'D': D,
      'answer': answer,
      'type': type,
      'subject': subject,
      'level': level
    };
  }
}
