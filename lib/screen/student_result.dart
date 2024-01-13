import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/data/marks.dart';
import 'dart:convert';
import 'package:school_app/models/student_model.dart';

class StudentResultPage extends StatefulWidget {
  @override
  _StudentResultPageState createState() => _StudentResultPageState();
}

class _StudentResultPageState extends State<StudentResultPage> {
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

      // ignore: unnecessary_null_comparison
      if (extractedData != null) {
        extractedData.forEach((studentId, studentData) {
          loadedStudents.add(Student.fromJson(studentData));
        });
      }

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
        title: Text('Student Results'),
        centerTitle: true,
        backgroundColor: Colors.red, // Change color to red
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red.shade50,
              Colors.red.shade100, // Darker shade of red
            ],
          ),
        ),
        child: students.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey.shade200, // Light grey color for Card
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      title: Text(students[index].fullName),
                      subtitle: Text('ID: ${students[index].id}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MarksPage(student: students[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
