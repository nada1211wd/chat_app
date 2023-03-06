import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:chat_app/screens/signin_screen.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(  
      debugShowCheckedModeBanner: false,
      title: 'chat app',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),

    initialRoute: WelcomeScreen.screenRoute,
        routes: {
      WelcomeScreen.screenRoute: (context) => const WelcomeScreen(),
      SignInScreen.screenRoute: (context) => const SignInScreen(),
      RegistrationScreen.screenRoute: (context) => const RegistrationScreen(),
      ChatScreen.screenRoute: (context) => const ChatScreen(),
    }
    );
  }
}

