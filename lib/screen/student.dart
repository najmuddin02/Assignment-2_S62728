import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/models/student_model.dart'; 
import 'package:school_app/screen/add_student.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    final url = Uri.https(
        'school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/students.json');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Student> loadedStudents = [];
      extractedData.forEach((studentId, studentData) {
        loadedStudents.add(Student.fromJson(studentData));
      });
      setState(() {
        students = loadedStudents;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddStudentPage()),
          );
          loadStudents(); // Reload the students
        },
        child: Icon(Icons.add),
      ),
      body: students.isEmpty
          ? Center(child: Text('No students found.'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(students[index].id),
                  subtitle: Text('class: ${students[index].kelas}'),
                );
              },
            ),
    );
  }
}