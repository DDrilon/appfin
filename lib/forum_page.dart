import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'message_detail_page.dart'; // Assurez-vous d'importer la page de détail des messages

class ForumPage extends StatefulWidget {
  final int userId;

  ForumPage({required this.userId});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<Message> messages = [];
  List<Application> applications = [];
  Application? selectedApplication;
  final TextEditingController _messageController = TextEditingController();
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchMessages();
    fetchApplications();
  }

  Future<void> fetchMessages() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/messages'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          messages = jsonResponse.map((message) => Message.fromJson(message)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load messages';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchApplications() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/applications'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          applications = (data as List).map((app) => Application.fromJson(app)).toList();
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load applications';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching applications: $e';
      });
    }
  }

  Future<void> submitMessage() async {
    if (_messageController.text.isEmpty || selectedApplication == null) {
      setState(() {
        errorMessage = 'Please enter a message and select an application';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/messages'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_utilisateur': widget.userId,
          'text_messages': _messageController.text,
          'date_messages': DateTime.now().toIso8601String(),
          'id_application': selectedApplication!.id,
        }),
      );

      if (response.statusCode == 200) {
        _messageController.clear(); // Clear the text field
        selectedApplication = null; // Reset selected application
        fetchMessages(); // Refresh messages list
      } else {
        setState(() {
          errorMessage = 'Failed to submit message';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error submitting message: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(messages[index].text),
                    subtitle: Text(
                        'By ${messages[index].username} on ${messages[index].date}\n'
                            'Application: ${messages[index].applicationName}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageDetailPage(
                            messageId: messages[index].id,
                            userId: widget.userId, // Passez userId ici aussi
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          if (applications.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<Application>(
                hint: Text('Select Application'),
                value: selectedApplication,
                onChanged: (Application? value) {
                  setState(() {
                    selectedApplication = value;
                  });
                },
                items: applications.map((Application app) {
                  return DropdownMenuItem<Application>(
                    value: app,
                    child: Text(app.name),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Your Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: submitMessage,
                child: Text('Submit Message'),
              ),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ]
        ],
      ),
    );
  }
}

class Application {
  final int id;
  final String name;
  final String description;

  Application({required this.id, required this.name, required this.description});

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Message {
  final int id;
  final String username;
  final String text;
  final String date;
  final String applicationName; // Ajoutez ce champ

  Message({
    required this.id,
    required this.username,
    required this.text,
    required this.date,
    required this.applicationName, // Ajoutez ce champ au constructeur
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      text: json['text'] ?? '',
      date: json['date'] ?? '',
      applicationName: json['application_name'] ?? '', // Extraire le nom de l'application
    );
  }
}
