import 'package:flutter/material.dart';
import 'package:flash_x/screens/registration_screen.dart';
import 'package:flash_x/screens/login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late Animation logoAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
      //upperBound: 100,
    );
    logoAnimation =
        CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = ColorTween(
            begin: Color.fromARGB(255, 221, 198, 156),
            end: Color.fromARGB(255, 196, 216, 226))
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: animation.value,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'icon',
                    child: Container(
                      child: Image.asset("images/ico.png"),
                      height: logoAnimation.value * 100,
                    ),
                  ),
                ],
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "FlashChat",
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(244, 31, 29, 29),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  elevation: 5.0,
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () {
                      //Go to login screen.
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Log In',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () {
                      //Go to registration screen.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()),
                      );
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
