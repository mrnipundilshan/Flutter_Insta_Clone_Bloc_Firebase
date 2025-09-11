import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/auth/domain/entities/app_user.dart';
import 'package:insta_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:insta_clone/features/profile/presentation/components/bio_box.dart';
import 'package:insta_clone/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:insta_clone/features/profile/presentation/cubits/profile_state.dart';
import 'package:insta_clone/features/profile/presentation/pages/edit_profile_page.dart';

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
  void initState() {
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
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        //loaded
        if (state is ProfileLoaded) {
          // get the loaded user
          final user = state.profileUser;

          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
              centerTitle: true,
              actions: [
                // edit profile button
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(user: user),
                    ),
                  ),
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),

            // body
            body: Column(
              children: [
                // email
                Text(
                  user.email,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 25),

                // profile pic
                CachedNetworkImage(
                  imageUrl: user.profileImageUrl,

                  // loading
                  placeholder: (contextm, url) =>
                      const CircularProgressIndicator(),

                  // error -> failed to load
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                    size: 72,
                  ),

                  // loaded
                  imageBuilder: (context, imageProvider) => Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // bio box
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                BioBox(text: user.bio),

                // posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 25),
                  child: Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        //loading
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Center(child: Text("No Profile Found"));
        }
      },
    );
  }
}
