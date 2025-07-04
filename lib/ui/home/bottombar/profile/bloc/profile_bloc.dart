import 'package:bloc/bloc.dart';
import 'package:butterfly/data/local/database/entity/user/user_entity.dart';
import 'package:butterfly/data/repository/auth/auth_repository.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final IAuthRepository _authRepository;

  ProfileBloc(this._authRepository)
      : super(ProfileLoading()) {

      on<LoadProfileEvent>((event, emit) async {
        try {
          emit(ProfileLoading());
          final user = await _authRepository.getLoggedInUser();
          AppLogger.showError('User: $user');
          if (user != null) {
            emit(ProfileLoaded(user: user));
          } else {
            emit(ProfileError(message: 'User not found'));
          }
        } catch (e) {
          emit(ProfileError(message: 'An error occurred: $e'));
        }
      });

    on<LogoutEvent>((event, emit) async {
      try {
        _authRepository.logout(); 
        emit(ProfileLoggedOut());
      } catch (e) {
        emit(ProfileError(message: 'An error occurred during logout: $e'));
      }
    });


    }
}
