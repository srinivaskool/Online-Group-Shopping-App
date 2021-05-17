import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/RoundButton.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation =
        ColorTween(begin: Colors.blue, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
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
                    height: 60.0,
                  ),
                ),
                SizedBox(
                  width: 250.0,
                  child: ColorizeAnimatedTextKit(
                      onTap: () {
                        print("Tap Event");
                      },
                      text: [
                        "Online Store",
                      ],
                      textStyle: TextStyle(
                          fontSize: 40.0, fontWeight: FontWeight.bold),
                      colors: [
                        Colors.purple,
                        Colors.blue,
                        Colors.yellow,
                        Colors.red,
                      ],
                      textAlign: TextAlign.start,
                      alignment:
                          AlignmentDirectional.topStart // or Alignment.topLeft
                      ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundButton(
              colour: Colors.blueAccent,
              text: 'Log In',
              icon: Icons.exit_to_app,
              onpressed: () {
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              },
            ),
            RoundButton(
              colour: Colors.blue,
              text: 'Register',
              icon:Icons.library_add,
              onpressed: () {
                Navigator.pushReplacementNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
