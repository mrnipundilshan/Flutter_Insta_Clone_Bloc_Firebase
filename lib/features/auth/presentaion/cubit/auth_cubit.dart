/* Auth Cubit: state managment */

import 'package:bloc/bloc.dart';
import 'package:insta_clone/features/auth/domain/entities/app_user.dart';
import 'package:insta_clone/features/auth/domain/repository/auth_repository.dart';
import 'package:insta_clone/features/auth/presentaion/cubit/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AppUser? _currentUser;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  //check if user is already authenticated
  void checkAuth() async {
    final AppUser? user = await authRepository.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  //get current user
  AppUser? get currentUser => _currentUser;

  //login with email + paswword
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepository.loginWithEmailPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  //register with email + paswword
  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepository.registerWithEmailPassword(
        name,
        email,
        password,
      );

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  //logout
  Future<void> logout() async {
    authRepository.logout();
    emit(Unauthenticated());
  }
}
