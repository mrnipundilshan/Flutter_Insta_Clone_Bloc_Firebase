/* 
Follow Button

this is a follow / unfollow button

-------------------------

to use this widget, you need:

    - a function (e.g: toggleFollow() ),
    - isFllowing (e.g. false -> then we will show follow button instead of unfollow button)

*/

import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue,
      child: Text(isFollowing ? "Unfollow" : "Follow"),
    );
  }
}
