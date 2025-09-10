import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/auth/data/firebase_auth_repo.dart';
import 'package:insta_clone/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:insta_clone/features/auth/presentaion/cubit/auth_states.dart';
import 'package:insta_clone/features/auth/presentaion/pages/auth_page.dart';
import 'package:insta_clone/features/home/presentation/pages/home_page.dart';
import 'package:insta_clone/features/profile/data/firebase_profile_repo.dart';
import 'package:insta_clone/features/profile/presentaion/cubits/profile_cubit.dart';
import 'package:insta_clone/themes/light_mode.dart';

/*
  App - Root Level

  Repository: for the database
    - firebase

  Bloc Providers: for state management
    - auth
    - profile
    - post
    - search
    - theme
  
  check Auth State
    - unauthenticated -> auth page (login/register)
    - authenticated -> home page


*/

class MainApp extends StatelessWidget {
  // auth repo
  final authRepo = FirebaseAuthRepo();

  // profile repo
  final profileRepo = FirebaseProfileRepo();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //provide cubit to app
    return MultiBlocProvider(
      providers: [
      // auth cubit
      BlocProvider(create: (context) =>AuthCubit(authRepository: authRepo)..checkAuth(),),

      // profile cubit
      BlocProvider(create: (context) => ProfileCubit(profileRepo: profileRepo))
    
    ], child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: BlocConsumer<AuthCubit, AuthState>(
        //listen for the errors
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, authstate) {
          print(authstate);
          // if unauthenticated -> auth page (login/register)
          if (authstate is Unauthenticated) {
            return const AuthPage();
          }
          if (authstate is Authenticated) {
            return const HomePage();
          }
          //loading
          else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    ),);
  }
}
