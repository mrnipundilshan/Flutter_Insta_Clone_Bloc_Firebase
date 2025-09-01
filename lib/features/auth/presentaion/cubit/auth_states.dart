/* Auth State */

import 'package:insta_clone/features/auth/domain/entities/app_user.dart';

abstract class AuthState {}

//initial
class AuthInitial extends AuthState {}

//loading
class AuthLoading extends AuthState {}

//authenticated
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}

//unauthenticated
class Unauthenticated extends AuthState {}

//error..
class AuthError extends AuthState {
  final String messagge;
  AuthError(this.messagge);
}
