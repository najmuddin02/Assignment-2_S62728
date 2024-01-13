class Student {
  String id;
  String fullName;
  int age;
  String gender;
  String kelas;
  String state;

  Student(
      {required this.id,
      required this.fullName,
      required this.age,
      required this.gender,
      required this.kelas,
      required this.state});

  // Convert a Student into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'class': kelas,
      'state': state,
    };
  }

  // A factory constructor for creating a Student from a JSON object
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      age: int.parse(
          json['age'].toString()), // Ensuring the age is treated as an integer
      gender: json['gender'] as String,
      kelas: json['class'] as String,
      state: json['state'] as String,
    );
  }

  Student copy({
    String? id,
    String? fullName,
    int? age,
    String? gender,
    String? kelas,
    String? state,
  })
  {
    return Student(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      kelas: kelas ?? this.kelas,
      state: state ?? this.state,
    );
  }
  
  Student copyWith({
    String? id,
    String? fullName,
    int? age,
    String? gender,
    String? kelas,
    String? state,
  })
  {
    return Student(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      kelas: kelas ?? this.kelas,
      state: state ?? this.state,
    );
  }

  void save() {
    // Implement your save logic here
    // For example, you can save the teacher data to a database
  }
}
