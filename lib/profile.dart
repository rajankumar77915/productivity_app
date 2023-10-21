import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productivity_app/Login.dart';
import 'package:productivity_app/env.dart';
import 'package:http/http.dart' as http;

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPass = false; // To toggle password visibility

  @override
  void initState() {
    super.initState();

    // Fetch the secure storage data
    fetchSecureStorageData();
  }

  String userId='';

  Future<void> fetchSecureStorageData() async {
    // Get the stored email and password
    final storage = FlutterSecureStorage();
    String? storedEmail = await storage.read(key: 'email');
    String? storedPassword = await storage.read(key: 'password');
    String ? userId1=await storage.read(key: 'user_id');
    String ? username=await storage.read(key: 'username');
    // Set the value of the text form controllers
    setState(() {
      _emailController.text = storedEmail ?? '';
      _passwordController.text = storedPassword ?? '';
       _usernameController.text = username  ??'';
      userId=userId1 ?? '';
      print(userId);
    });
  }

  Future<String> updateUserProfile(String email, String username, String password) async {
    print("-----------------------");
    print(userId);
    final response = await http.post(
      Uri.parse('$api/api/v1/user/update/${userId}'),
      body: jsonEncode({
        'email': email,
        'name': username,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    print("suceess update");
    if (response.statusCode == 200) {
      final storage = FlutterSecureStorage();
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'username', value: username);

      setState(() {
        fetchSecureStorageData();
      });
      print("suceess update");

      return "sucess";
    } else {
      throw Exception('Failed to update user profile');
    }
  }

  Future<void> logout() async {
    final storage = FlutterSecureStorage();
    await storage.deleteAll(); // Clear all stored data
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SignIn()),
          (Route<dynamic> route) => false, // Clear the navigation stack
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _usernameController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      cursorColor: Colors.white,
                      obscureText: _showPass,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPass ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPass = !_showPass;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text;
                  final username = _usernameController.text;
                  final password = _passwordController.text;

                  // Update the user profile
                  try {
                    final message = await updateUserProfile(email, username, password);

                    // Show a success message to the user
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(message),
                    ));
                  } catch (error) {
                    // Handle error
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
