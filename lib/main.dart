import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productivity_app/Login.dart';
import 'package:productivity_app/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that the Flutter binding is initialized.

  final storage = FlutterSecureStorage();
  String? storedEmail = await storage.read(key: 'email');
  String? storedPassword = await storage.read(key: 'password');
  String? user_id = await storage.read(key: 'user_id');
  runApp(
    MaterialApp(
      home: storedEmail != null && storedPassword != null ? Home(user_id: user_id,) : SignIn(),
    ),
  );
}

