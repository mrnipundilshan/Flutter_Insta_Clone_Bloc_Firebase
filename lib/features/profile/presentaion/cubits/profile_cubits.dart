import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/profile/domain/repository/profile_repo.dart';
import 'package:insta_clone/features/profile/presentaion/cubits/profile_state.dart';

class ProfileCubits extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubits({required this.profileRepo}) : super(ProfileInitial());

  //fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User Not Found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
