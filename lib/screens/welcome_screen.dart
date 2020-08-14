import 'package:together/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:together/components/RoundButton.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // For providing custom animations we need to give different parametrers -
  // Animation ticker
  // Animation controller
  // Animation value

  // When we have to reference the class object in the  class's own code, we use 'this' for current state welcomeScreen
  AnimationController controller;
  // To use curved animation create an animation variable first and inside the init state initialise to curvedAnimation

  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    //1
    animation = ColorTween(begin: Colors.orange[700], end: Colors.yellow)
        .animate(controller);
    // The above animation takkes 2 colours  starting and ending ones and then shows transition of colours
    // You have to use .animate() otherwise error
    // We apply the animation to our animation controller

    // You take a tween, animate it, and apply to an animationController
    controller.forward();
    //2
    controller.addListener(() {
      // IMPORTANT
      setState(() {});
      // setstate to change the animation values for animation
    });
    //3
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  // Since animations consume resources, its important to dispose them as to override it and dispose the controller
  // so that it does not eat all memory and resources

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: Colors.white,
      // because the animation is of type  colour and is applied to animationController -> controller
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    // height: animation.value*100,
                    height: 60,
                    // Changes the logo size like an animation
                    // This animation is quite linear and ticks 60 times a second
                    // For different type such as curved animation use CurvedAnimationClass
                    // Note the height and logo
                  ),
                ),
                Text(
                  'Flash Chat',
                  // '${controller.value.toInt()}%',
                  // Shows animation of 0 to 100
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundButton(
              colour: Colors.lightBlueAccent,
              navigate: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              info: 'Log In',
            ),
            //4
            RoundButton(
              colour: Colors.blueAccent,
              navigate: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              info: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}

//1 - Remove upperbound for curves -> upperBound: 100.0

// animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);

// Parent accepts an animationController and curve accepts a 'Curves.curvevalue'
// While using curves make sure  the upperbound is not greater than 1 as they are made on scale from 0 to 1 as the
// previous one shows error

// The decelerate animation makes it larger. To go to the opposite way, use controller.reverse(from: 1.0)

// For  looping the animation, first we need to add a statusListener()

// controller.forward();
// To move the animations forward

//2 - animation.addStatusListener((status) {
//   print(status);
//   // On completion returns status completed for forward animation and AnimationStatus.dismissed for reverse animation
//   if (status == AnimationStatus.completed) {
//     controller.reverse(from: 1.0);
//   } else if (status == AnimationStatus.dismissed) {
//     controller.forward();
//   }
// });

// 3 - We can listen to the value of the controller  which is the actual animation

// vsync  relates  to animation ticker
// In this case the ticker provider is going to be our state object
// WelcomeScreenState  inherits from the state Welcome Screen because of the word 'extends' and to turn the welcome
// screen into something that acts as a ticker we have to use the keyword 'with' and specify that this class
// state Welcome Screen can act as a 'singletickerproviderstatemixin'

// It is like upscaling the state of welcome screen with a single animation. For multiple animations use
// 'tickerproviderstatemixin'

// Mxins provide your class many capabilities

// vsync: is looking for a ticker where we provide the WelcomeScreenState value as the ticker

// 4 - Padding(
//   padding: EdgeInsets.symmetric(vertical: 16.0),
//   child: Material(
//     color: Colors.blueAccent,
//     borderRadius: BorderRadius.circular(30.0),
//     elevation: 5.0,
//     child: MaterialButton(
//       onPressed: () {
//         //Go to registration screen.
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (context) => RegistrationScreen(),
//         //   ),
//         // );
//         Navigator.pushNamed(context, RegistrationScreen.id);
//       },
//       minWidth: 200.0,
//       height: 42.0,
//       child: Text(
//         'Register',
//       ),
//     ),
//   ),
// ),
