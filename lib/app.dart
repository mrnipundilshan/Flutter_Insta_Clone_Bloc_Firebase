import 'package:flutter/material.dart';
import 'package:insta_clone/features/auth/presentaion/pages/auth_page.dart';
import 'package:insta_clone/themes/light_mode.dart';

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
