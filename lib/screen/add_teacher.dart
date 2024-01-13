import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTeacherPage extends StatefulWidget {
  @override
  _AddTeacherPageState createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  String id = '';
  String fullName = '';
  String phoneNumber = '';
  String gender = '';
  String subject = 'Mathematics';
  String state = 'Johor';
  final List<String> _genders = ['Male', 'Female'];

  Future<void> _saveTeacher() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/teachers.json');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'id': id,
            'fullName': fullName,
            'phoneNumber': phoneNumber,
            'gender': gender,
            'subject': subject,
            'state': state,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data Teacher added!')),
          );
          Navigator.of(context).pop();
        } else {
          throw Exception('Failed to add teacher');
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
        title: Text("Add Teacher"),
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
                          decoration: InputDecoration(labelText: 'Teacher ID'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter teacher ID';
                            }
                            if (!(value.startsWith('T'))) {
                              return 'Teacher ID must start with letter T';
                            }
                            String number = value.substring(1);
                            if (number.isEmpty ||
                                !number.runes.every((int rune) {
                                  var character = new String.fromCharCode(rune);
                                  return character
                                      .contains(new RegExp(r'[0-9]'));
                                })) {
                              return 'ID must be followed by numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            id = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Full Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter full name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            fullName = value!;
                          },
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Phone Number'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            // Regular expression for the format
                            RegExp phoneRegex = RegExp(r'^\d{3}-\d{7,9}$');
                            if (!phoneRegex.hasMatch(value)) {
                              return 'Phone number must be in the format XXX-XXXXXXX';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phoneNumber = value!;
                          },
                        ),
                        // Gender Radio Buttons
                        Column(
                          children: _genders.map((String value) {
                            return ListTile(
                              title: Text(value),
                              leading: Radio<String>(
                                value: value,
                                groupValue: gender,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    gender = newValue!;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField(
                          value: subject,
                          onChanged: (String? newValue) {
                            setState(() {
                              subject = newValue!;
                            });
                          },
                          items: [
                            'Mathematics',
                            'Science',
                            'History',
                            'English',
                            'Arabic'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Subject',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            subject = value!;
                          },
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField(
                          value: state,
                          onChanged: (String? newValue) {
                            setState(() {
                              state = newValue!;
                            });
                          },
                          items: [
                            'Johor',
                            'Kedah',
                            'Kelantan',
                            'Melaka',
                            'Negeri Sembilan',
                            'Pahang',
                            'Perak',
                            'Perlis',
                            'Pulau Pinang',
                            'Sabah',
                            'Sarawak',
                            'Selangor',
                            'Terengganu',
                            'Wilayah Persekutuan'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'State',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            state = value!;
                          },
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _saveTeacher,
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
