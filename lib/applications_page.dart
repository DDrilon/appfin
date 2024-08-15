import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'application_detail_page.dart'; // Assurez-vous que ce chemin est correct

class ApplicationsPage extends StatefulWidget {
  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  List<Application> applications = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/applications'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        print('Applications JSON response: $jsonResponse'); // Log the JSON response
        setState(() {
          applications = jsonResponse.map((app) => Application.fromJson(app)).toList();
          print('Parsed applications: $applications'); // Log the parsed applications
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load applications';
          isLoading = false;
        });
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching applications: $e';
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applications'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'All Applications:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  print('Displaying application: ${applications[index].name}'); // Debugging line
                  return ListTile(
                    title: Text(applications[index].name),
                    subtitle: Text(applications[index].description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplicationDetailPage(
                            applicationId: applications[index].id,
                            applicationName: applications[index].name,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Application {
  final int id; // Ajout de l'ID de l'application
  final String name;
  final String description;

  Application({required this.id, required this.name, required this.description});

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'], // Assurez-vous que l'ID est bien renvoyé par votre API
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Application{id: $id, name: $name, description: $description}';
  }
}
