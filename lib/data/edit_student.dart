import 'package:flutter/material.dart';
import 'package:school_app/models/student_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditStudentPage extends StatefulWidget {
  final Student student;

  EditStudentPage({required this.student});

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late Student _editedStudent;
  String? _selectedClass;
  String? _selectedState;
  List<String> _genders = ['Male', 'Female']; // Define gender options
  String? gender;

  @override
  void initState() {
    super.initState();
    _editedStudent = widget.student.copy();
    _selectedClass = _editedStudent.kelas; // Initialize with current subject
    _selectedState = _editedStudent.state;
    gender = _editedStudent.gender;
  }

  Future<void> updateStudent(Student student) async {
    // Firebase Realtime Database URL
    final databaseURL =
        'https://school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app';
    final studentURL = '$databaseURL/students/${student.id}.json';

    try {
      final studentJson = json.encode(student.toJson());
      final response = await http.patch(Uri.parse(studentURL),
          body: studentJson, headers: {'Content-Type': 'application/json'});

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
      _editedStudent = _editedStudent.copyWith(
        fullName: _editedStudent.fullName,
        age: _editedStudent.age,
        gender: gender,
        kelas: _selectedClass,
        state: _selectedState,
      );

      // Call the updateTeacher method with the edited teacher
      await updateStudent(_editedStudent);

      // Handle success case
      // For example: Show a success message or navigate back
      Navigator.of(context).pop(_editedStudent);
    } catch (error) {
      // Handle error case
      // For example: Show an error message
      final snackBar =
          SnackBar(content: Text('Error updating student: $error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop(_editedStudent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
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
                                initialValue: _editedStudent.id,
                                decoration: InputDecoration(labelText: 'ID'),
                                enabled: false,
                                onSaved: (value) {},
                              ),
                              TextFormField(
                                initialValue: _editedStudent.fullName,
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
                                  _editedStudent =
                                      _editedStudent.copyWith(fullName: value);
                                },
                              ),
                              TextFormField(
                                // ignore: unnecessary_null_comparison
                                initialValue: _editedStudent.age != null
                                    ? _editedStudent.age.toString()
                                    : '',
                                decoration: InputDecoration(labelText: 'Age'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType
                                    .number, // Ensures numeric keyboard
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your age';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Age must be a number';
                                  }
                                  int? age = int.parse(value);
                                  if (age < 0 || age > 120) {
                                    return 'Please enter a valid age';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedStudent = _editedStudent.copyWith(
                                      age: int.parse(value!));
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
                                value: _selectedClass,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedClass = newValue;
                                  });
                                },
                                items: <String>[
                                  'Jupiter',
                                  'Mercury',
                                  'Neptune',
                                  'Saturn',
                                  'Uranus',
                                  'Venus'
                                ].map<DropdownMenuItem<String>>((String value) {
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
                                  _editedStudent =
                                      _editedStudent.copyWith(kelas: value);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your class';
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
                                  _editedStudent =
                                      _editedStudent.copyWith(state: value);
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
