import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/auth/domain/entities/app_user.dart';
import 'package:insta_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:insta_clone/features/post/domain/entities/comment.dart';
import 'package:insta_clone/features/post/presentation/cubit/post_cubit.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  // current user
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.uid);
  }

  // show options for comment deletion
  void showOption() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Commet?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),

          // delete button
          TextButton(
            onPressed: () {
              context.read<PostCubit>().deleteComment(
                widget.comment.postId,
                widget.comment.id,
              );
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // name
          Text(
            widget.comment.userName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 12,
            ),
          ),

          const SizedBox(width: 10),

          // comment text
          Text(
            widget.comment.text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12,
            ),
          ),

          const Spacer(),

          // delete button
          if (isOwnPost)
            GestureDetector(
              onTap: showOption,
              child: Icon(
                Icons.more_horiz,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}
