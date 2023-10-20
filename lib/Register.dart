import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:productivity_app/env.dart';
import 'package:productivity_app/home.dart';

class Register extends StatefulWidget {
  const Register({Key? key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    super.initState();
  }

  var userName = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var confirmPass = TextEditingController();
  var showPassword = false;
  var iconChange = Icons.remove_red_eye;
  String _registrationMsg = "";

  Future<int> _submitForm() async {
    try {
      // Extract text from controllers
      final firstNameValue = userName.text.toString();
      final emailValue = email.text.toString();
      final passwordValue = password.text.toString();

      // Send the form data to  backend server for registration
      final response = await http.post(
        Uri.parse('$api/api/v1/user/signup'),
        body: jsonEncode({
          "name": firstNameValue,
          "email": emailValue,
          "password": passwordValue,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Registration successful
        return 1;
      } else {
        // Registration failed
        setState(() {
          _registrationMsg = 'Registration failed'; // Set the validation message
        });
        print('Registration failed ${response.body}');
        return response.statusCode;
      }
    } catch (error) {
      print("error: $error");
    }
    return  250;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xFF050406),
          ),
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30, left: 10),
                      child: SizedBox(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.subdirectory_arrow_left_rounded,
                            color: Color(0xFFE4E8EE),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Center(
                        child: Container(
                          child: RichText(
                            text: const TextSpan(children: [
                              TextSpan(
                                  text: 'Unlock ',
                                  style: TextStyle(
                                      color: Color(0xFFFF8800),
                                      fontFamily: 'um',
                                      fontSize: 45)),
                              TextSpan(
                                  text: 'your \n',
                                  style: TextStyle(
                                      color: Color(0xFFE4E8EE),
                                      fontFamily: 'um',
                                      fontSize: 35)),
                              TextSpan(
                                  text: 'Inner',
                                  style: TextStyle(
                                      color: Color(0xFFE4E8EE),
                                      fontFamily: 'um',
                                      fontSize: 35)),
                              TextSpan(
                                  text: ' Self ',
                                  style: TextStyle(
                                      color: Color(0xFFFFFF00),
                                      fontFamily: 'um',
                                      fontSize: 45)),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  bottom: 15, right: 15, left: 15),
                              child: TextField(
                                cursorRadius: const Radius.circular(10),
                                style: const TextStyle(
                                    color: Color(0xFFE4E8EE),
                                    fontSize: 15,
                                    fontFamily: 'cl'),
                                controller: userName,
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                      color: Color(0xFFBDC1C6),
                                      fontFamily: 'ul'),
                                  hintText: 'Name',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE4E8EE),
                                        width: 2,
                                      )),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFBDC1C6),
                                      )),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  bottom: 15, right: 15, left: 15),
                              child: TextField(
                                cursorRadius: const Radius.circular(10),
                                style: const TextStyle(
                                    color: Color(0xFFE4E8EE),
                                    fontSize: 15,
                                    fontFamily: 'cl'),
                                controller: email,
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                      color: Color(0xFFBDC1C6),
                                      fontFamily: 'ul'),
                                  hintText: 'Email Id',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE4E8EE),
                                        width: 2,
                                      )),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFBDC1C6),
                                      )),
                                  suffixIcon:
                                  const Icon(Icons.email),
                                  suffixIconColor:
                                  const Color(0xFFBDC1C6),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15),
                              child: TextField(
                                cursorRadius: const Radius.circular(10),
                                style: const TextStyle(
                                    color: Color(0xFFE4E8EE),
                                    fontSize: 15,
                                    fontFamily: 'cl'),
                                controller: password,
                                obscureText: showPassword,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                      color: Color(0xFFBDC1C6),
                                      fontFamily: 'ul'),
                                  hintText: 'Password',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE4E8EE),
                                        width: 2,
                                      )),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFBDC1C6),
                                      )),
                                  suffixIcon: IconButton(
                                    icon: Icon(iconChange,
                                        color: const Color(0xFFBDC1C6)),
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                        if (!showPassword) {
                                          iconChange = Icons.remove_red_eye;
                                        } else {
                                          iconChange = Icons.visibility_off;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15),
                              child: TextField(
                                cursorRadius: const Radius.circular(10),
                                style: const TextStyle(
                                    color: Color(0xFFE4E8EE),
                                    fontSize: 15,
                                    fontFamily: 'cl'),
                                controller: confirmPass,
                                obscureText: showPassword,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                      color: Color(0xFFBDC1C6),
                                      fontFamily: 'ul'),
                                  hintText: 'Confirm Password',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE4E8EE),
                                        width: 2,
                                      )),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFBDC1C6),
                                      )),
                                  suffixIcon: IconButton(
                                    icon: Icon(iconChange,
                                        color: const Color(0xFFBDC1C6)),
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                        if (!showPassword) {
                                          iconChange = Icons.remove_red_eye;
                                        } else {
                                          iconChange = Icons.visibility_off;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: InkWell(
                        onTap: () async {
                          String name = userName.text.toString();
                          String emailId = email.text.toString();
                          String Password = password.text.toString();
                          String cpassword = confirmPass.text.toString();

                          if (name == '') {
                            return;
                          }

                          if (Password != cpassword) {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Password Not Matched'),
                                content: const Text(
                                    'Confirm Password is not equal to Password'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (emailId != '') {
                            int? response = await _submitForm();
                            if (response == 1) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return Home();
                                  }));
                            } else if (response == 500) {
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Your Password is too weak'),
                                  content: const Text('Make strong Password'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (response == 404) {
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('User already exists'),
                                  content: const Text('Try to Login'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (response == 300) {
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Invalid Email'),
                                  content: const Text('Email is Badly formatted'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (response == 250) {
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Something went wrong'),
                                  content: const Text(''),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFFE4E8EE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Color(0xFF050406),
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
