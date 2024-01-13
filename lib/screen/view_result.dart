import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewResultPage extends StatefulWidget {
  final String studentId;

  ViewResultPage({required this.studentId});

  @override
  _ViewResultPageState createState() => _ViewResultPageState();
}

class _ViewResultPageState extends State<ViewResultPage> {
  Map<String, double>? marks;

  @override
  void initState() {
    super.initState();
    fetchMarks();
  }

  Future<void> fetchMarks() async {
    final url = Uri.parse(
        'https://school-management-app-e524d-default-rtdb.asia-southeast1.firebasedatabase.app/marks/${widget.studentId}.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final dynamic data = json.decode(response.body);
        if (data != null && data is Map<String, dynamic>) {
          setState(() {
            marks = data.map((key, value) => MapEntry(key, value.toDouble()));
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('No marks available')));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to fetch marks')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching marks: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Result"),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Student ID: ${widget.studentId}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),
                      marks != null && marks!.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: marks!.length,
                              itemBuilder: (context, index) {
                                String subject = marks!.keys.elementAt(index);
                                double score = marks![subject]!;
                                return ListTile(
                                  title: Text(subject),
                                  trailing: Text(score.toString()),
                                );
                              },
                            )
                          : Text('No marks available'),
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
}
