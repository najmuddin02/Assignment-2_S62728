import 'package:flutter/material.dart';
import 'package:school_app/models/teacher_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditTeacherPage extends StatefulWidget {
  final Teacher teacher;

  EditTeacherPage({required this.teacher});

  @override
  _EditTeacherPageState createState() => _EditTeacherPageState();
}

class _EditTeacherPageState extends State<EditTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late Teacher _editedTeacher;
  String? _selectedSubject;
  String? _selectedState;
  List<String> _genders = ['Male', 'Female']; // Define gender options
  String? gender;

  @override
  void initState() {
    super.initState();
    _editedTeacher = widget.teacher.copy();
    _selectedSubject = _editedTeacher.subject;
    _selectedState = _editedTeacher.state;
    gender = _editedTeacher.gender;
  }

  Future<void> updateTeacher(Teacher teacher) async {
    // Firebase Realtime Database URL
    final databaseURL =
        'https://school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app';
    final teacherURL = '$databaseURL/teachers/${teacher.id}.json';

    try {
      final teacherJson = json.encode(teacher.toJson());
      final response = await http.patch(Uri.parse(teacherURL),
          body: teacherJson, headers: {'Content-Type': 'application/json'});

      if (response.statusCode >= 400) {
        // Handle errors
        throw Exception('Could not update teacher data.');
      }
    } catch (error) {
      rethrow; // Throw the error to be handled by the caller
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      // Update the edited teacher's properties
      _editedTeacher = _editedTeacher.copyWith(
        fullName: _editedTeacher.fullName,
        phoneNumber: _editedTeacher.phoneNumber,
        gender: gender,
        subject: _selectedSubject,
        state: _selectedState,
      );

      // Call the updateTeacher method with the edited teacher
      await updateTeacher(_editedTeacher);

      // Handle success case
      // For example: Show a success message or navigate back
      Navigator.of(context).pop(_editedTeacher);
    } catch (error) {
      // Handle error case
      // For example: Show an error message
      final snackBar =
          SnackBar(content: Text('Error updating teacher: $error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop(_editedTeacher);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Teacher'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
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
                              // Disable editing of ID
                              TextFormField(
                                initialValue: _editedTeacher.id,
                                decoration: InputDecoration(labelText: 'ID'),
                                enabled: false,
                                onSaved: (value) {},
                              ),
                              TextFormField(
                                initialValue: _editedTeacher.fullName,
                                decoration:
                                    InputDecoration(labelText: 'Full Name'),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter full name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedTeacher =
                                      _editedTeacher.copyWith(fullName: value);
                                },
                              ),
                              TextFormField(
                                initialValue: _editedTeacher.phoneNumber,
                                decoration:
                                    InputDecoration(labelText: 'Phone Number'),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  // Regular expression for the format
                                  RegExp phoneRegex =
                                      RegExp(r'^\d{3}-\d{7,9}$');
                                  if (!phoneRegex.hasMatch(value)) {
                                    return 'Phone number must be in the format XXX-XXXXXXX';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedTeacher = _editedTeacher.copyWith(
                                      phoneNumber: value);
                                },
                              ),
                              SizedBox(height: 16),
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
                              SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedSubject,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedSubject = newValue;
                                  });
                                },
                                items: <String>[
                                  'Mathematics',
                                  'Science',
                                  'History',
                                  'English',
                                  'Arabic'
                                ].map<DropdownMenuItem<String>>((String value) {
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
                                  _editedTeacher =
                                      _editedTeacher.copyWith(subject: value);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your subject';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedState,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedState = newValue;
                                  });
                                },
                                items: <String>[
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
                                ].map<DropdownMenuItem<String>>((String value) {
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
                                  _editedTeacher =
                                      _editedTeacher.copyWith(state: value);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your state';
                                  }
                                  return null;
                                },
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
