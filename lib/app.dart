import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/auth/data/firebase_auth_repo.dart';
import 'package:insta_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:insta_clone/features/auth/presentation/cubit/auth_states.dart';
import 'package:insta_clone/features/auth/presentation/pages/auth_page.dart';
import 'package:insta_clone/features/home/presentation/pages/home_page.dart';
import 'package:insta_clone/features/post/data/firebase_post_repo.dart';
import 'package:insta_clone/features/post/presentation/cubit/post_cubit.dart';
import 'package:insta_clone/features/profile/data/firebase_profile_repo.dart';
import 'package:insta_clone/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:insta_clone/features/search/data/firebase_search_repo.dart';
import 'package:insta_clone/features/search/presentation/cubits/search_cubit.dart';
import 'package:insta_clone/features/storage/data/firebase_storage_repo.dart';
import 'package:insta_clone/themes/theme_cubit.dart';

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
  final firebaseauthRepo = FirebaseAuthRepo();

  // profile repo
  final firebaseprofileRepo = FirebaseProfileRepo();

  // storage repo
  final firebasestorageRepo = FirebaseStorageRepo();

  // post repo
  final firebasePostRepo = FirebasePostRepo();

  // search repo
  final firebaseSearchRepo = FirebaseSearchRepo();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //provide cubit to app
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider(
          create: (context) =>
              AuthCubit(authRepository: firebaseauthRepo)..checkAuth(),
        ),

        // profile cubit
        BlocProvider(
          create: (context) => ProfileCubit(
            profileRepo: firebaseprofileRepo,
            storageRepo: firebasestorageRepo,
          ),
        ),

        //post cubit
        BlocProvider(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: firebasestorageRepo,
          ),
        ),

        // search cubit
        BlocProvider(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        ),

        // theme cubit
        BlocProvider(create: (context) => ThemeCubit()),
      ],

      // bloc builder: themes
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: currentTheme,

          // bloc builder: check current auth state
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
        ),
      ),
    );
  }
}
