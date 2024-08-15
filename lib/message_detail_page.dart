import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessageDetailPage extends StatefulWidget {
  final int messageId;
  final int userId; // Ajoutez cette ligne pour recevoir l'ID de l'utilisateur

  MessageDetailPage({required this.messageId, required this.userId});

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  late Message message;
  List<Reponse> reponses = [];
  bool isLoading = true;
  String errorMessage = '';
  final TextEditingController _responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMessageDetails();
  }

  Future<void> fetchMessageDetails() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/messages/${widget.messageId}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          message = Message.fromJson(data['message']);
          reponses = (data['reponses'] as List)
              .map((reponse) => Reponse.fromJson(reponse))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load message details';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching message details: $e';
        isLoading = false;
      });
    }
  }

  Future<void> submitResponse() async {
    final String responseText = _responseController.text;

    if (responseText.isEmpty) {
      setState(() {
        errorMessage = 'Response cannot be empty';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/messages/${widget.messageId}/reponses'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_utilisateur': widget.userId,
          'text_reponse': responseText,
          'date_reponse': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        _responseController.clear(); // Clear the text field
        fetchMessageDetails(); // Refresh the message details
      } else {
        setState(() {
          errorMessage = 'Failed to submit response';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error submitting response: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Details'),
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
            // Display the message
            Text(
              'Message:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(message.text, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),

            // Display the responses
            Text(
              'Responses:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: reponses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(reponses[index].text),
                    subtitle: Text('By ${reponses[index].username} on ${reponses[index].date}'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),

            // TextField for new response
            TextField(
              controller: _responseController,
              decoration: InputDecoration(
                labelText: 'Your response',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Submit button
            Center(
              child: ElevatedButton(
                onPressed: submitResponse,
                child: Text('Submit Response'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final int id;
  final String username;
  final String text;
  final String date;

  Message({required this.id, required this.username, required this.text, required this.date});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      text: json['text'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

class Reponse {
  final String username;
  final String text;
  final String date;

  Reponse({required this.username, required this.text, required this.date});

  factory Reponse.fromJson(Map<String, dynamic> json) {
    return Reponse(
      username: json['username'] ?? '',
      text: json['text'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
