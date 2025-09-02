import 'package:flutter/material.dart';
import 'package:insta_clone/features/auth/presentaion/pages/login_page.dart';
import 'package:insta_clone/features/auth/presentaion/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //initially, show login page
  bool showLoginPage = true;

  //void togglePages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage();
    } else {
      return RegisterPage();
    }
  }
}
