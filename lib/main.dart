import 'package:flutter/material.dart';
import 'package:flash_x/screens/welcome_screen.dart';
import 'package:flash_x/screens/chat_screen.dart';
import 'package:flash_x/screens/registration_screen.dart';
import 'package:flash_x/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashX());
}

class FlashX extends StatelessWidget {
  const FlashX({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen()
      },
    );
  }
}
