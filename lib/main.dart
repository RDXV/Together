import 'package:flutter/material.dart';
import 'package:together/screens/welcome_screen.dart';
import 'package:together/screens/login_screen.dart';
import 'package:together/screens/registration_screen.dart';
import 'package:together/screens/chat_screen.dart';

// TODO: The name of package was co.appbrewery... and so app crashed a lot in
// app\src\main\java\co\appbrewery\flash_chat\MainActivity.java

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: WelcomeScreen(),
      initialRoute: 'welcome',
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}

// While using the other route method like
// initialrout: '/welcome';
// routes{
// '/welcome':(context)=> WelcomeScreen(),
// ...
// }

// Then this app will crash because there has to be atleast 1 '/' (root) route and give error
//Global key was used multiple times
// If using that, make sure oe of the keys has at least one of the '/' as a route

// However, that is not a problem with the above used method
