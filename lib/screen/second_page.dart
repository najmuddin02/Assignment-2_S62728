import 'package:flutter/material.dart';
import 'package:school_app/data/record_discipline.dart';
import 'package:school_app/data/teacher_data.dart';
import 'package:school_app/screen/student_result.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.red, // Red themed AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red.shade100,
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            _buildOptionCard(
              context, 
              'Teachers Profile', 
              Icons.person_outline, 
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherDataPage())),
            ),
            _buildOptionCard(
              context, 
              'Examination Marks', 
              Icons.school, 
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => StudentResultPage())),
            ),
            _buildOptionCard(
              context, 
              'Student Discipline Records', 
              Icons.warning_amber_outlined, 
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecordDisciplinePage())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
