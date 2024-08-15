import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApplicationDetailPage extends StatefulWidget {
  final int applicationId;
  final String applicationName;

  ApplicationDetailPage({required this.applicationId, required this.applicationName});

  @override
  _ApplicationDetailPageState createState() => _ApplicationDetailPageState();
}

class _ApplicationDetailPageState extends State<ApplicationDetailPage> {
  List<Message> messages = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/application/${widget.applicationId}/messages'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded response: $data');

        if (data.isEmpty) {
          setState(() {
            errorMessage = 'No messages found for this application.';
            isLoading = false;
          });
        } else {
          setState(() {
            messages = (data as List).map((message) => Message.fromJson(message)).toList();
            isLoading = false;
          });
        }
      } else if (response.statusCode == 404) {
        setState(() {
          errorMessage = 'No messages found for this application.';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load messages: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching messages: $e';
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.applicationName),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : messages.isEmpty
          ? Center(child: Text('No messages found for this application.'))
          : ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(messages[index].text),
            subtitle: Text('By ${messages[index].username} on ${messages[index].date}'),
          );
        },
      ),
    );
  }
}

class Message {
  final int id;
  final String text;
  final String date;
  final String username;

  Message({required this.id, required this.text, required this.date, required this.username});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'] ?? '',
      date: json['date'] ?? '',
      username: json['username'] ?? '',
    );
  }
}
