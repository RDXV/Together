import 'package:flutter/material.dart';
import 'package:together/components/RoundButton.dart';
import 'package:together/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
// Register using firebase authentication, authorise inside state

class RegistrationScreen extends StatefulWidget {
  static String id = 'register';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  // We create private auth variable to autorise users using the firebase servers
  String email, password;
  // Can change the email and so, not final
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Wrap hero widget inside flexible widget so that for different screen sizes, the image would not go off
              // the screen
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                // textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                // specifically for adding email address making it easier
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration:
                    textBoxDecoration.copyWith(hintText: 'Enter  your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                // textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration:
                    textBoxDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundButton(
                  info: 'Register',
                  colour: Colors.blueAccent,
                  navigate: () async {
                    // print(email);
                    // print(password);
                    // Whenuser presses on the register button, show the spinner
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      // if succesful, then the this user gets stored in authentication object as the current user
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                      print('hello');
                    }
                    // Creates a future Authresult user with email and password
                    // Put inside try and catch as user can enter incorrect email or password
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
