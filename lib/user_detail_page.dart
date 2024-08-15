import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetailPage extends StatefulWidget {
  final int userId;

  UserDetailPage({required this.userId});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late String username;
  List<Message> messages = [];
  List<Application> applications = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/user/${widget.userId}/details'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Log the entire response for debugging
        print('Full JSON response: $data');

        setState(() {
          username = data['userDetails']['username'] ?? '';
          messages = (data['userDetails']['messages'] as List?)
              ?.map((message) => Message.fromJson(message))
              .toList() ?? [];
          applications = (data['applications'] as List?)
              ?.map((application) => Application.fromJson(application))
              .toList() ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load user details';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching user details: $e';
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
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
              'Username: $username',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Messages:',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index].text),
                    subtitle: Text('On ${messages[index].date}'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Applications:',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(applications[index].name),
                    subtitle: Text(applications[index].description),
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

class Message {
  final String text;
  final String date;

  Message({required this.text, required this.date});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

class Application {
  final String name;
  final String description;

  Application({required this.name, required this.description});

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
