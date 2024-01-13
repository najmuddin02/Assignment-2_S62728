import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/data/edit_student.dart';
import 'package:school_app/models/student_model.dart';
import 'package:school_app/screen/add_student.dart';
import 'dart:convert';

class StudentDataPage extends StatefulWidget {
  @override
  _StudentDataPageState createState() => _StudentDataPageState();
}

class _StudentDataPageState extends State<StudentDataPage> {
  List<Student> students = [];
  Map<String, List<Student>> studentsByClass = {};

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    const url =
        'https://school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app/students.json';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Student> loadedStudents = [];

      extractedData.forEach((studentId, studentData) {
        loadedStudents.add(Student.fromJson(studentData));
      });

      setState(() {
        students = loadedStudents;
        groupStudentsByClass();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }

  void groupStudentsByClass() {
    studentsByClass = {};
    for (var student in students) {
      if (studentsByClass.containsKey(student.kelas)) {
        studentsByClass[student.kelas]!.add(student);
      } else {
        studentsByClass[student.kelas] = [student];
      }
    }
  }

Future<void> deleteStudent(String id) async {
    final url =
        'https://school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app/students/$id.json';

    final existingStudentIndex =
        students.indexWhere((student) => student.id == id);
    Student? existingStudent = students[existingStudentIndex];
    setState(() {
      students.removeAt(existingStudentIndex);
    });

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode >= 400) {
        setState(() {
          students.insert(existingStudentIndex, existingStudent!);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Could not delete student. Error: ${response.body}')),
        );
      } else {
        existingStudent = null;
      }
    } catch (error) {
      print('Error deleting student: $error');
      setState(() {
        students.insert(existingStudentIndex, existingStudent!);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete student. Error: $error')),
      );
    }
  }

  void updateStudentInList(Student updatedStudent) {
    setState(() {
      final index =
          students.indexWhere((student) => student.id == updatedStudent.id);
      if (index != -1) {
        students[index] = updatedStudent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Profile'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: students.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.red.shade50,
                    Colors.red.shade100,
                  ],
                ),
              ),
              child: ListView(
                padding: EdgeInsets.all(8),
                children: studentsByClass.keys.map((className) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ExpansionTile(
                      title: Text('Class $className'),
                      leading: Icon(Icons.class_),
                      children: studentsByClass[className]!
                          .map((student) => ListTile(
                                title: Text(student.fullName),
                                subtitle: Text('ID: ${student.id}'),
                                onTap: () async {
                                  final updatedStudent = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditStudentPage(student: student),
                                    ),
                                  );

                                  if (updatedStudent != null) {
                                    updateStudentInList(updatedStudent);
                                  }
                                },
                              ))
                          .toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddStudentPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        tooltip: 'Add Student',
      ),
    );
  }
}
