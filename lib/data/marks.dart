import 'package:flutter/material.dart';
import 'package:school_app/models/student_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarksPage extends StatefulWidget {
  final Student student;

  MarksPage({required this.student});

  @override
  _MarksPageState createState() => _MarksPageState();
}

class _MarksPageState extends State<MarksPage> {
  final Map<String, double> _marks = {
    'Mathematics': 0.0,
    'Science': 0.0,
    'History': 0.0,
    'English': 0.0,
    'Arabic': 0.0,
  };

  Future<void> submitMarks() async {
    final url = Uri.parse('https://school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app/marks/${widget.student.id}.json');
    try {
      final response = await http.put(
        url,
        body: json.encode(_marks),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marks updated successfully')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save marks')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Marks for ${widget.student.fullName}'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade50, Colors.blue.shade100],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Card(
                elevation: 5,
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Text('Student ID: ${widget.student.id}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 20),
                      ..._marks.keys.map((subject) {
                        return _buildSubjectSlider(subject);
                      }).toList(),
                      ElevatedButton(
                        onPressed: submitMarks,
                        child: Text('Submit Marks'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectSlider(String subject) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$subject: ${_marks[subject]!.toStringAsFixed(0)}', style: TextStyle(fontSize: 16)),
        Slider(
          value: _marks[subject]!,
          min: 0,
          max: 100,
          divisions: 100,
          label: _marks[subject]!.round().toString(),
          onChanged: (double value) {
            setState(() {
              _marks[subject] = value;
            });
          },
        ),
      ],
    );
  }
}
