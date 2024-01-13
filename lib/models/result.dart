class StudentResult {
  String id;
  String studentId;
  String subject;
  double marks;

  StudentResult({required this.id, required this.studentId, required this.subject, required this.marks});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'subject': subject,
      'marks': marks,
    };
  }
}
