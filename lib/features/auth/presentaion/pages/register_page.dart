/* Login Page */

/*on this page, an exiting user can logi with their, email and password*/

/*once the user successfully logged, they will be rederected to the home page.

if uesr doesnt has account yet, they can go register page to from here to create one */

import 'package:flutter/material.dart';
import 'package:insta_clone/features/auth/presentaion/components/my_login_button.dart';
import 'package:insta_clone/features/auth/presentaion/components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //textcontrollers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return //Scaffold
    Scaffold(
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

                //create account message
                Text(
                  "Let's create an account for you",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: width * 0.04,
                  ),
                ),

                const SizedBox(height: 20),

                //email textfiled
                MyTextField(
                  controller: nameController,
                  hintText: "Name",
                  obsecureText: false,
                ),

                const SizedBox(height: 10),

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

                const SizedBox(height: 10),

                //confirm pw textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obsecureText: true,
                ),

                const SizedBox(height: 25),
                //login
                MyButton(onTap: () {}, text: "Register"),

                const SizedBox(height: 50),

                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already a member?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        " Login",
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
