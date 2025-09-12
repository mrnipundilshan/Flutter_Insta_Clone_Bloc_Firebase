import 'package:insta_clone/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;
  final List<String> followers;
  final List<String> following;

  ProfileUser({
    required this.bio,
    required this.profileImageUrl,
    required super.uid,
    required super.email,
    required super.name,
    required this.followers,
    required this.following,
  });

  //method to update profile user
  ProfileUser copyWith({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? newFollowers,
    List<String>? newFollowing,
  }) {
    return ProfileUser(
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      uid: uid,
      email: email,
      name: name,
      followers: newFollowers ?? followers,
      following: newFollowing ?? following,
    );
  }

  //convert profile user-> json
  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }

  //convert profile json -> user
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      bio: json['bio'],
      profileImageUrl: json['profileImageUrl'],
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
    );
  }
}
