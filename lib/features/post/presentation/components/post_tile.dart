import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/auth/domain/entities/app_user.dart';
import 'package:insta_clone/features/auth/presentation/components/my_text_field.dart';
import 'package:insta_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:insta_clone/features/post/domain/entities/comment.dart';
import 'package:insta_clone/features/post/domain/entities/post.dart';
import 'package:insta_clone/features/post/presentation/cubit/post_cubit.dart';
import 'package:insta_clone/features/post/presentation/cubit/post_state.dart';
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

  /* comment */

  // comment text comtrolle
  final commentTextController = TextEditingController();

  // open comment box -> user wants to type a new comment
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyTextField(
          controller: commentTextController,
          hintText: "Type a Comment",
          obsecureText: false,
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),

          // save button
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void addComment() {
    // create the new comment
    final newCommnet = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: widget.post.userId,
      userName: widget.post.userName,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newCommnet);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
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
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(Icons.comment),
                ),

                Text(widget.post.comments.length.toString()),

                const Spacer(),

                // timestamp
                Text(widget.post.timestamp.toString()),
              ],
            ),
          ),

          // caption
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                // username
                Text(
                  widget.post.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(width: 10),

                // text
                Text(widget.post.text),
              ],
            ),
          ),

          // comment section
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              // loaded
              if (state is PostsLoaded) {
                // final individula post
                final post = state.posts.firstWhere(
                  (post) => (post.id == widget.post.id),
                );

                if (post.comments.isNotEmpty) {
                  // how many comments to show
                  int showCommentCount = post.comments.length;

                  // comment section
                  return ListView.builder(
                    itemCount: showCommentCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // get individual commnet
                      final comment = post.comments[index];

                      // comment tile ui
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          children: [
                            // name
                            Text(
                              comment.userName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(width: 10),

                            // comment text
                            Text(comment.text),
                          ],
                        ),
                      );
                    },
                  );
                }
              }
              // loading ..
              if (state is PostsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // error
              else if (state is PostsError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text("Something went wrong.."));
              }
            },
          ),
        ],
      ),
    );
  }
}
