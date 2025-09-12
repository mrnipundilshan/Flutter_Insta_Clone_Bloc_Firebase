/* Login Page */

/*on this page, an exiting user can logi with their, email and password*/

/*once the user successfully logged, they will be rederected to the home page.

if uesr doesnt has account yet, they can go register page to from here to create one */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/auth/presentation/components/my_login_button.dart';
import 'package:insta_clone/features/auth/presentation/components/my_text_field.dart';
import 'package:insta_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:insta_clone/responsive/constrained_scaffold.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //textcontrollers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //login button pressed
  void login() {
    // prepare email & password
    final String email = emailController.text;
    final String password = passwordController.text;

    //auth cubit
    final authCubit = context.read<AuthCubit>();

    //ensure that the email & password fileds are not empty
    if (email.isNotEmpty && password.isNotEmpty) {
      //login
      authCubit.login(email, password);
    }
    //display error if some  fields are empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return //Scaffold
    ConstrainedScaffold(
      //body
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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

                const SizedBox(height: 20),

                //email textfiled
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obsecureText: false,
                ),

                const SizedBox(height: 10),

                //pw textfield
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obsecureText: true,
                ),

                const SizedBox(height: 25),
                //login
                MyButton(onTap: login, text: "Log In"),

                const SizedBox(height: 50),
                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        " Register now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
