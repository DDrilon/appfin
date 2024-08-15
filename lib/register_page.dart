import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/user_model.dart';
import 'models/application_model.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          applications = (data as List).map((app) => Application.fromJson(app)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load applications';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching applications: $e';
        isLoading = false;
      });
    }
  }

  Future<void> checkUsernameAndRegister() async {
    final String username = _usernameController.text;

    if (username.isEmpty) {
      setState(() {
        errorMessage = 'Username is required';
      });
      return;
    }

    try {
      final checkResponse = await http.post(
        Uri.parse('http://10.0.2.2:3000/check-username'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      if (checkResponse.statusCode == 409) {
        setState(() {
          errorMessage = 'Username already exists. Please choose another one.';
        });
      } else if (checkResponse.statusCode == 200) {
        registerUser();
      } else {
        setState(() {
          errorMessage = 'Failed to check username. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error checking username: $e';
      });
      print('Error: $e');
    }
  }

  Future<void> registerUser() async {
    final String username = _usernameController.text;
    final DateTime registrationDate = DateTime.now();

    User newUser = User(username: username, registrationDate: registrationDate);

    List<int> selectedApplicationIds = applications
        .where((app) => app.isSelected)
        .map((app) => app.id)
        .toList();

    try {
      final userResponse = await http.post(
        Uri.parse('http://10.0.2.2:3000/utilisateur'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newUser.toJson()),
      );

      print('User registration response status: ${userResponse.statusCode}');
      print('User registration response body: ${userResponse.body}');

      if (userResponse.statusCode == 200) {
        final userId = json.decode(userResponse.body)['id'];

        for (int appId in selectedApplicationIds) {
          final appResponse = await http.post(
            Uri.parse('http://10.0.2.2:3000/user/$userId/applications'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'id_application': appId}),
          );

          print('Application registration response status: ${appResponse.statusCode}');
          print('Application registration response body: ${appResponse.body}');

          if (appResponse.statusCode != 200) {
            setState(() {
              errorMessage = 'Failed to register application $appId for user';
            });
            return;
          }
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userId: userId),
          ),
        );
      } else {
        setState(() {
          errorMessage = 'Failed to register user';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error registering user: $e';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            Text(
              'Select Applications:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(applications[index].name),
                    value: applications[index].isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        applications[index].isSelected = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: checkUsernameAndRegister,
                child: Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
