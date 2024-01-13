import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/models/student_model.dart';
import 'package:school_app/data/add_case.dart';
import 'dart:convert';

class RecordDisciplinePage extends StatefulWidget {
  @override
  _RecordDisciplinePageState createState() => _RecordDisciplinePageState();
}

class _RecordDisciplinePageState extends State<RecordDisciplinePage> {
  List<Student> students = [];

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

      // Check if the extracted data is not null
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
        title: Text('Record Discipline'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Container(
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
        child: students.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Card(
                    color: Colors.grey.shade200,
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Dismissible(
                      key: Key(student.id),
                      background: Container(color: Colors.red),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        deleteStudent(student.id);
                      },
                      child: ListTile(
                        title: Text(student.fullName),
                        subtitle: Text('ID: ${student.id}'),
                        onTap: () async {
                          final updatedStudent = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddCasePage(student: student),
                            ),
                          );

                          if (updatedStudent != null) {
                            updateStudentInList(updatedStudent);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
