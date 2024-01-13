import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  String id = '';
  String fullName = '';
  String age = '';
  String gender = '';
  String kelas = 'Jupiter';
  String state = 'Johor';

  // Gender Radio Button Options
  final List<String> _genders = ['Male', 'Female'];

  Future<void> _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.https(
          'school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/students.json');

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
              'age': int.parse(age), // Age is parsed to an integer
              'gender': gender,
              'class': kelas,
              'state': state,
            },
          ),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data Student added!')),
          );
          Navigator.of(context).pop();
        } else {
          throw Exception('Failed to add student');
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
        title: Text("Add Student"),
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
                          decoration: InputDecoration(labelText: 'Student ID'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter student ID';
                            }
                            if (!(value.startsWith('S'))) {
                              return 'Student ID must start with letter S';
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
                          decoration: InputDecoration(labelText: 'Age'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter age';
                            }
                            int? ageValue = int.tryParse(value);
                            if (ageValue == null) {
                              return 'Age must be a number';
                            }
                            if (ageValue < 0 || ageValue > 120) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            age = int.parse(value!) as String;
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
                          value: kelas,
                          onChanged: (String? newValue) {
                            setState(() {
                              kelas = newValue!;
                            });
                          },
                          items: [
                            'Jupiter',
                            'Mercury',
                            'Neptune',
                            'Saturn',
                            'Uranus',
                            'Venus'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Class',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            kelas = value!;
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
                          onPressed: _saveStudent,
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
