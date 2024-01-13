import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/models/student_model.dart';

class AddCasePage extends StatefulWidget {
  final Student student;

  AddCasePage({required this.student});

  @override
  _AddCasePageState createState() => _AddCasePageState();
}

class _AddCasePageState extends State<AddCasePage> {
  final _formKey = GlobalKey<FormState>();
  late String id;
  late String fullName;
  String caseType = '';
  String kes = 'Bullying';

  // Gender Radio Button Options
  final List<String> _caseType = ['Normal', 'Heavy'];

  @override
  void initState() {
    super.initState();
    id = widget.student.id;
    fullName = widget.student.fullName;
  }

  Future<void> _saveStudentCase() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.https(
          'school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/student_record.json');

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'id': id,
              'fullName': fullName,
              'caseType': caseType,
              'case': kes,
            },
          ),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Student Discipline Case Record added!')),
          );
          Navigator.of(context).pop();
        } else {
          throw Exception('Failed to add case record');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Case"),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          initialValue: id,
                          decoration: InputDecoration(labelText: 'Student ID'),
                          readOnly: true,
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          initialValue: fullName,
                          decoration:
                              InputDecoration(labelText: 'Student Name'),
                          readOnly: true,
                        ),
                        // CaseType Radio Buttons
                        Column(
                          children: _caseType.map((String value) {
                            return ListTile(
                              title: Text(value),
                              leading: Radio<String>(
                                value: value,
                                groupValue: caseType,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    caseType = newValue!;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField(
                          value: kes,
                          onChanged: (String? newValue) {
                            setState(() {
                              kes = newValue!;
                            });
                          },
                          items: [
                            'Bullying',
                            'Sexual harassment',
                            'Fighting',
                            'Smoking',
                            'Disrespect',
                            'Not doing homework'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Case Detail',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            kes = value!;
                          },
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _saveStudentCase,
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
