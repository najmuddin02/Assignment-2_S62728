import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/models/teacher_model.dart';
import 'package:school_app/screen/add_teacher.dart';

class TeacherPage extends StatefulWidget {
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  List<Teacher> teachers = [];

  @override
  void initState() {
    super.initState();
    loadTeachers();
  }

  Future<void> loadTeachers() async {
    final url = Uri.https(
        'school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/teachers.json');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Teacher> loadedTeachers = [];
      extractedData.forEach((teacherId, teacherData) {
        loadedTeachers.add(Teacher.fromJson(teacherData));
      });
      setState(() {
        teachers = loadedTeachers;
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
        title: Text('Teacher Dashboard'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddTeacherPage()),
          );
          loadTeachers(); // Refresh the list after adding a teacher
        },
        child: Icon(Icons.add),
      ),
      body: teachers.isEmpty
          ? Center(child: Text('No teachers found.'))
          : ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(teachers[index].id),
                  subtitle: Text('Full Name: ${teachers[index].fullName}'),
                );
              },
            ),
    );
  }
}
