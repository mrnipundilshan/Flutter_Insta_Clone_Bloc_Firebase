import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/auth/domain/entities/app_user.dart';
import 'package:insta_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:insta_clone/features/post/domain/entities/post.dart';
import 'package:insta_clone/features/post/presentation/cubit/post_cubit.dart';
import 'package:insta_clone/features/profile/domain/entities/profile_user.dart';
import 'package:insta_clone/features/profile/presentation/cubits/profile_cubit.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;

  // current user
  AppUser? currentUser;

  // post user
  ProfileUser? postUser;

  // on startup
  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fecthPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fecthPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  // show options for deletion
  void showOption() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),

          // delete button
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  /* likes */

  // user tapped like button
  void toggleLikePost() {
    // current like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // optimistically like & update ui
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid); // unlike
      } else {
        widget.post.likes.add(currentUser!.uid); // like
      }
    });

    // update like
    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((
      error,
    ) {
      // if there's any error, revert back to original values
      setState(() {
        if (isLiked) {
          widget.post.likes.remove(currentUser!.uid); // revert unlike
        } else {
          widget.post.likes.add(currentUser!.uid); // revert like
        }
      });
    });
  }

  // build ui
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          // Top section: profile pic / name / delete button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // profile pic
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : const Icon(Icons.person),

                const SizedBox(width: 10),

                // name
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                // delete button
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOption,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),

          // image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          // buttons -> like, comment, timestamp
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      // like button
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser!.uid)
                              ? Colors.red
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      const SizedBox(width: 5),

                      // like count
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // comment button
                Icon(Icons.comment),

                Text("0"),

                const Spacer(),

                // timestamp
                Text(widget.post.timestamp.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
