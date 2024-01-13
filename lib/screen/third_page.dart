import 'package:flutter/material.dart';
import 'package:school_app/data/student_data.dart';
import 'package:school_app/screen/view_result.dart';

class ThirdPage extends StatelessWidget {
  final String studentId; // Assume this is passed to or defined in ThirdPage

  ThirdPage({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.red, // Consistent red themed AppBar
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
              'Student Profile',
              Icons.person_outline,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => StudentDataPage())),
            ),
            _buildOptionCard(
              context,
              'Exam Results',
              Icons.school,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewResultPage(studentId: studentId))),
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
