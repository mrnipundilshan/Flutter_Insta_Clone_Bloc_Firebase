import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/features/auth/presentaion/pages/auth_page.dart';
import 'package:insta_clone/firebase_options.dart';
import 'package:insta_clone/themes/light_mode.dart';

void main() async {
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //run app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightMode,
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
