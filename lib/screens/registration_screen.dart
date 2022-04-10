import 'package:flash_x/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_x/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _saving = false;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: "icon",
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/ico.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(255, 48, 44, 44)),
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kMessageTextFieldDecoration.copyWith(
                    hintText: "Enter Your Email",
                    hintStyle: TextStyle(color: Colors.teal))),
            SizedBox(
              height: 8.0,
            ),
            TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(255, 48, 44, 44)),
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kMessageTextFieldDecoration.copyWith(
                    hintText: "Enter Your Password",
                    hintStyle: TextStyle(color: Colors.teal))),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async {
                    //Implement registration functionality.
                    //print("$email\n$password");
                    try {
                      setState(() {
                        _saving = true;
                        
                      });
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    } on Exception catch (e) {
                      print(e);
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
