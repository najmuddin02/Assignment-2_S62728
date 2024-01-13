class Teacher {
  String id;
  String fullName;
  String phoneNumber;
  String gender;
  String subject;
  String state;

  Teacher(
      {required this.id,
      required this.fullName,
      required this.phoneNumber,
      required this.gender,
      required this.state,
      required this.subject});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'subject': subject,
      'state': state,
    };
  }

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      gender: json['gender'] as String,
      subject: json['subject'] as String,
      state: json['state'] as String,
    );
  }

  // Implement the copy method
  Teacher copy({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? gender,
    String? subject,
    String? state,
  }) {
    return Teacher(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      subject: subject ?? this.subject,
      state: state ?? this.state,
    );
  }

  Teacher copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? gender,
    String? subject,
    String? state,
  }) {
    return Teacher(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      subject: subject ?? this.subject,
      state: state ?? this.state,
    );
  }

  // Map<String, String?> validate() {
  //   Map<String, String?> errors = {};
  //   if (fullName.isEmpty) {
  //     errors['fullName'] = 'Please enter a full name';
  //   }
  //   // Add more validation for other fields as needed
  //   if (phoneNumber.isEmpty) {
  //     errors['phoneNumber'] = 'Please enter a phone number';
  //   }
  //   if (gender.isEmpty) {
  //     errors['gender'] = 'Please enter the gender';
  //   }
  //   if (subject.isEmpty) {
  //     errors['subject'] = 'Please enter the subject';
  //   }
  //   if (state.isEmpty) {
  //     errors['state'] = 'Please enter the state';
  //   }

  //   return errors;
  // }

  void save() {
    // Implement your save logic here
    // For example, you can save the teacher data to a database
  }
}
