/* Login Page */

/*on this page, an exiting user can logi with their, email and password*/

/*once the user successfully logged, they will be rederected to the home page.

if uesr doesnt has account yet, they can go register page to from here to create one */

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return //Scaffold
    Scaffold(
      //body
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              //logo
              Icon(
                Icons.lock_open_rounded,
                size: width * 0.2,
                color: Theme.of(context).colorScheme.primary,
              ),

              SizedBox(height: height * 0.03),

              //welcomback message
              Text(
                "Welcome back, you've been missed!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: width * 0.04,
                ),
              ),

              //email textfiled

              //pw textfield

              //login

              //mnot a member? register now
            ],
          ),
        ),
      ),
    );
  }
}
