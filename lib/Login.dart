import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productivity_app/env.dart';
import 'package:productivity_app/home.dart';
import 'package:productivity_app/main.dart';
import 'Register.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget{

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  @override
  void initState() {
    super.initState();
  }

  var iconChange = Icons.remove_red_eye;
  var showPassword = true;
  var email = TextEditingController();
  var password = TextEditingController();
  var user_Id;
  Future<int> _submitForm() async {
    // Form is valid, perform login
    final email1 = email.text.toString();
    final passwordd   = password.text.toString();
    // Send the email and password to your backend server for validation
    final response = await http.post(
      Uri.parse('$api/api/v1/user/login'),
      body: jsonEncode({"email":email1 , "password":passwordd}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final storage = FlutterSecureStorage();
      final Dres=jsonDecode(response.body);
      final existUser = Dres['existUser'];
      final username = existUser['name'];
      print("user name is : $username \n");
       user_Id = existUser['_id'];
      await storage.write(key: 'email', value: email1);
      await storage.write(key: 'password', value: passwordd);
      await storage.write(key: 'user_id', value: user_Id);
      await storage.write(key: 'username', value: username);
      return 1;
    } else {
      // Login failed
      // setState(() {
      //   _loginMessage = 'Invalid email or password'; // Set the validation message
      // });
      print('Login failed');
      return response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,

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
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Let\'s Sign you in', style: TextStyle(
                                color: Color(0xFFE4E8EE),
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                fontFamily: 'CascadiaCode',
                                height: 1.5),),
                            Text('Welcome Back.', style: TextStyle(
                                color: Color(0xFFE4E8EE), fontSize: 25,
                                fontFamily: 'cl', height: 1.5),),
                            Text('You\'ve been missed', style: TextStyle(
                                color: Color(0xFFE4E8EE), fontSize: 25,
                                fontFamily: 'cl', height: 1.5),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 2,
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                      child: Container(
                        padding: const EdgeInsets.only(
                            bottom: 15, right: 15, left: 15),
                        child: TextField(
                          cursorRadius: Radius.circular(10),

                          style: const TextStyle(color: Color(0xFFE4E8EE),
                              fontSize: 15,
                              fontFamily: 'cl'),
                          controller: email,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: Color(0xFFBDC1C6), fontFamily: 'ul'),
                            hintText: 'Email Id',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE4E8EE),
                                  width: 2,
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFFBDC1C6),
                                )
                            ),
                            suffixIcon: const Icon(Icons.email),
                            suffixIconColor: const Color(0xFFBDC1C6),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 80,
                      child: Container(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: TextField(
                          cursorRadius: const Radius.circular(10),

                          style: const TextStyle(color: Color(0xFFE4E8EE),
                              fontSize: 15,
                              fontFamily: 'cl'),
                          controller: password,
                          obscureText: showPassword,
                          obscuringCharacter: '*',
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: Color(0xFFBDC1C6), fontFamily: 'ul'),
                            hintText: 'Password',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE4E8EE),
                                  width: 2,
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFFBDC1C6),
                                )
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(iconChange, color: Color(0xFFBDC1C6)),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                  if (!showPassword) {
                                    iconChange = Icons.remove_red_eye;
                                  }
                                  else {
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
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Don\'t have an Account ?', style: TextStyle(
                                  color: Color(0xFFBDC1C6),
                                  fontSize: 14,
                                  fontFamily: 'ul')),
                              TextButton(onPressed: () =>
                              {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Register(),))
                              }, child: Text('Register')),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: InkWell(

                            onTap: () async {

                              try{

                                int? response = await _submitForm();
                                print("----------------------omomomom $response");
                                if(response == 1)
                                {

                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){ return Home(user_id: user_Id);}));
                                }
                                else if(response == 400)
                                {
                                  return showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text('INVALID User'),
                                      content: const Text(''),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, 'Cancel'),
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
                                else if(response == 501)
                                {
                                  return showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text('INVALID Password'),
                                      content: const Text(''),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, 'Cancel'),
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
                                else if(response == 250)
                                {
                                  return showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Something went wrong'),
                                      content: const Text(''),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, 'Cancel'),
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
                              catch(e)
                              {
                                print("-------------------------er");
                                print(e.toString());
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFFE4E8EE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('Sign In', style: TextStyle(
                                color: Color(0xFF050406), fontSize: 18,),
                                textAlign: TextAlign.center,),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
