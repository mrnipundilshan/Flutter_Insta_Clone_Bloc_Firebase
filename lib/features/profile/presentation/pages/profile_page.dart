import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/auth/domain/entities/app_user.dart';
import 'package:insta_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:insta_clone/features/post/presentation/components/post_tile.dart';
import 'package:insta_clone/features/post/presentation/cubit/post_cubit.dart';
import 'package:insta_clone/features/post/presentation/cubit/post_state.dart';
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

  // on startup
  @override
  void initState() {
    super.initState();

    //load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  // current user
  late AppUser? currentUser = authCubit.currentUser;

  // posts
  int postCount = 0;

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
            body: ListView(
              children: [
                // email
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
                const SizedBox(height: 10),

                // list of posts from this user
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    // post loaded
                    if (state is PostsLoaded) {
                      // filter post by user id
                      final userPosts = state.posts
                          .where((post) => post.userId == widget.uid)
                          .toList();

                      postCount = userPosts.length;

                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: postCount,
                        itemBuilder: (context, index) {
                          // get individual post
                          final post = userPosts[index];

                          // return as post tile ui
                          return PostTile(
                            post: post,
                            onDeletePressed: () =>
                                context.read<PostCubit>().deletePost(post.id),
                          );
                        },
                      );
                    }
                    // posts loading
                    else if (state is PostsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return const Center(child: Text("No Posts.."));
                    }
                  },
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
