/* 

Auth Repository - Outlines the possible auth operations for this app

*/

import 'package:insta_clone/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> loginWithEmailPassword(String email, String password);

  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  );

  Future<void> logout();

  Future<AppUser?> getCurrentUser();
}
