/*
This page will display a tab babr to show
  - list of followers
  - list of following
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/profile/presentation/cubits/profile_cubit.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    // Tab Controller
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // app bar
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "Followers"),
              Tab(text: "Following"),
            ],
          ),
        ),

        // tab bar view
        body: TabBarView(
          children: [
            _buildUserList(followers, "No followers", context),
            _buildUserList(followers, "No Following", context),
          ],
        ),
      ),
    );
  }

  // build user list, given a list of profile uids
  Widget _buildUserList(
    List<String> uids,
    String emptyMessage,
    BuildContext context,
  ) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              // get each uid
              final uid = uids[index];

              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  // user loaded
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return ListTile(title: Text(user.name));
                  }
                  // loading
                  else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(title: Text("Loading.."));
                  }
                  // not found
                  else {
                    return ListTile(title: Text("Users Not Found.."));
                  }
                },
              );
            },
          );
  }
}
