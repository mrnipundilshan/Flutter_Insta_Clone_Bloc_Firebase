import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/* 
Profile states

This will be displayed on all profile pages

-------------------------------------------

Number of:

  - posts
  - followers
  - following

*/

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followersCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStats({
    super.key,
    required this.postCount,
    required this.followersCount,
    required this.followingCount,
    required this.onTap,
  });

  // Build UI
  @override
  Widget build(BuildContext context) {
    // text style for count
    var textStyleForCount = TextStyle(
      fontSize: 20,
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    // text style for text
    var textStyleForText = TextStyle(
      color: Theme.of(context).colorScheme.primary,
    );

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // posts
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(postCount.toString(), style: textStyleForCount),
                Text("Posts", style: textStyleForText),
              ],
            ),
          ),

          // followers
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followersCount.toString(), style: textStyleForCount),
                Text("Followers", style: textStyleForText),
              ],
            ),
          ),

          // following
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followingCount.toString(), style: textStyleForCount),
                Text("Following", style: textStyleForText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
