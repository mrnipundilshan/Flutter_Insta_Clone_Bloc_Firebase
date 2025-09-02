import 'package:insta_clone/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;

  ProfileUser({
    required this.bio,
    required this.profileImageUrl,
    required super.uid,
    required super.email,
    required super.name,
  });

  //method to update profile user
  ProfileUser copyWith({String? newBio, String? newProfileImageUrl}) {
    return ProfileUser(
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      uid: uid,
      email: email,
      name: name,
    );
  }

  //convert profile user-> json
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
    );
  }
}
