import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String info;
  final Function navigate;
  final Color colour;

  RoundButton({this.colour, this.info, @required this.navigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: navigate,
          // onPressed: () {
          //Go to login screen.
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => LoginScreen(),
          //   ),
          // );
          // Navigator.pushNamed(context, RegistrationScreen.id);
          // },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            info,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
