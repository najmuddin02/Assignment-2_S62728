import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/data/edit_teacher.dart';
import 'package:school_app/models/teacher_model.dart';
import 'package:school_app/screen/add_teacher.dart';
import 'dart:convert';

class TeacherDataPage extends StatefulWidget {
  @override
  _TeacherDataPageState createState() => _TeacherDataPageState();
}

class _TeacherDataPageState extends State<TeacherDataPage> {
  List<Teacher> teachers = [];
  Map<String, List<Teacher>> teachersBySubject = {};

  @override
  void initState() {
    super.initState();
    fetchTeachers();
  }

  Future<void> fetchTeachers() async {
    const url =
        'https://school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app/teachers.json';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Teacher> loadedTeachers = [];

      // ignore: unnecessary_null_comparison
      if (extractedData != null) {
        extractedData.forEach((teacherId, teacherData) {
          loadedTeachers.add(Teacher.fromJson(teacherData));
        });
      }

      setState(() {
        teachers = loadedTeachers;
        groupTeachersBySubject();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }

  void groupTeachersBySubject() {
    teachersBySubject = {};
    for (var teacher in teachers) {
      if (teachersBySubject.containsKey(teacher.subject)) {
        teachersBySubject[teacher.subject]!.add(teacher);
      } else {
        teachersBySubject[teacher.subject] = [teacher];
      }
    }
  }

  Future<void> deleteTeacher(String id) async {
    final url =
        'https://school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app/teachers/$id.json';

    final existingTeacherIndex =
        teachers.indexWhere((teacher) => teacher.id == id);
    Teacher? existingTeacher = teachers[existingTeacherIndex];
    setState(() {
      teachers.removeAt(existingTeacherIndex);
    });

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode >= 400) {
        setState(() {
          teachers.insert(existingTeacherIndex, existingTeacher!);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Could not delete teacher. Error: ${response.body}')),
        );
      } else {
        existingTeacher = null;
      }
    } catch (error) {
      print('Error deleting teacher: $error');
      setState(() {
        teachers.insert(existingTeacherIndex, existingTeacher!);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete teacher. Error: $error')),
      );
    }
  }

  void updateTeacherInList(Teacher updatedTeacher) {
    setState(() {
      final index =
          teachers.indexWhere((teacher) => teacher.id == updatedTeacher.id);
      if (index != -1) {
        teachers[index] = updatedTeacher;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Profile'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: teachers.isEmpty
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
                padding: EdgeInsets.all(8), // Adjust padding as needed
                children: teachersBySubject.keys.map((subject) {
                  return Card(
                    // Wrap each ExpansionTile in a Card for better UI
                    elevation: 4, // Add some shadow
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ExpansionTile(
                      title: Text(subject),
                      leading: Icon(_getSubjectIcon(subject)),
                      children: teachersBySubject[subject]!
                          .map((teacher) => ListTile(
                                title: Text(teacher.fullName),
                                subtitle: Text('Phone: ${teacher.phoneNumber}'),
                                onTap: () async {
                                  final updatedTeacher = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditTeacherPage(teacher: teacher),
                                    ),
                                  );

                                  if (updatedTeacher != null) {
                                    updateTeacherInList(updatedTeacher);
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
              .push(MaterialPageRoute(builder: (context) => AddTeacherPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        tooltip: 'Add Teacher',
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Mathematics':
        return Icons.calculate;
      case 'Science':
        return Icons.science;
      case 'History':
        return Icons.history_edu;
      case 'English':
        return Icons.menu_book;
      case 'Arabic':
        return Icons.language;
      default:
        return Icons.subject;
    }
  }
}
