import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'HomePage.dart';
import 'UserHomePage.dart';
import 'RegistrationPage.dart';

class ApiResponse {
  final bool success;
  final String message;
  final int role;

  ApiResponse({
    required this.success,
    required this.message,
    required this.role,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      role: json['role'] ?? 2, // Default role is 2 (User)
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email;
  late String password;

  @override
  void initState() {
    super.initState();
    email = "";
    password = "";
  }

  Future<void> performLogin() async {
    try {
      if (email.isEmpty || password.isEmpty) {
        _showErrorDialog("Error", "Email and password are required.");
        return;
      }

      final response = await http.post(
        Uri.parse("http://localhost/api/Login.php"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        ApiResponse apiResponse =
        ApiResponse.fromJson(jsonDecode(response.body));
        if (apiResponse.success) {
          _handleSuccessfulLogin(apiResponse);
        } else {
          _showErrorDialog("Login Failed", apiResponse.message);
        }
      } else {
        _showErrorDialog(
          "HTTP Request Failed",
          "Failed to connect to the server. Status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      _showErrorDialog("Error", "An unexpected error occurred: $e");
    }
  }

  void _handleSuccessfulLogin(ApiResponse apiResponse) {
    print("Login successful");

    if (apiResponse.role == 1) {
      _navigateToPage(HomePage());
    } else {
      _navigateToPage(UserHomePage());
    }
  }

  void _navigateToPage(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle( color: Colors.white)),
        backgroundColor: Colors.blue,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                performLogin();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set your desired button color
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _navigateToPage(RegistrationPage());
              },
              style: TextButton.styleFrom(
              ),
              child: Text(
                "Don't have an account? Register here",
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
    theme: ThemeData(
      primaryColor: Colors.blue, // Set your desired primary color
      hintColor: Colors.white,
    ),
  ));
}
