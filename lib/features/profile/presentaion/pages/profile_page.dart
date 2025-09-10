import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/auth/domain/entities/app_user.dart';
import 'package:insta_clone/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:insta_clone/features/profile/presentaion/cubits/profile_cubit.dart';
import 'package:insta_clone/features/profile/presentaion/cubits/profile_state.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  //
  @override
  void initState(){
    super.initState();

    //load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  // current user
  late AppUser? currentUser = authCubit.currentUser;

  //build ui
  @override
  Widget build(BuildContext context) {
  // Scaffold
  return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state){
    //loaded
    if (state is ProfileLoaded){
      // get the loaded user
      final user = state.profileUser;

      return Scaffold(
      appBar: AppBar(title: Text(user.name), 
      foregroundColor: Theme.of(context).colorScheme.primary,
      centerTitle: true),
    );

    // body
    }

    //loading
    else if(state is ProfileLoading){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    } else {
      return const Center(child: Text("No Profile Found"),);
    }
  
  },
  );
  }
}
