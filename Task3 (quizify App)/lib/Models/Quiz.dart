class Quiz {
  final String subject;
  final String type;
  final int questions;

  Quiz({required this.subject, required this.type, required this.questions});

  factory Quiz.fromMap(Map<String, dynamic> data) {
    return Quiz(
      subject: data['subject'],
      type: data['type'],
      questions: data['questions'],
    );
  }
}
