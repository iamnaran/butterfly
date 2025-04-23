import 'package:bloc/bloc.dart';
import 'package:butterfly/core/database/entity/user/user_entity.dart';
import 'package:butterfly/core/network/base/api_status.dart';
import 'package:butterfly/core/network/base/resource.dart';
import 'package:butterfly/core/repository/auth/auth_repository.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final IAuthRepository authRepository;


  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<LoginState> emit) async {
  emit(LoginLoading());

  try {
    await emit.forEach<Resource<UserEntity?>>(
      authRepository.login(event.username, event.password),
      onData: (result) {
        AppLogger.showLog('Bloc Login result: ${result.status}');

        if (result.status == ApiStatus.loading) {
          return LoginLoading();
        } else if (result.status == ApiStatus.success) {
          return LoginSuccess(result.data!);
        } else if (result.status == ApiStatus.failure) {
          return LoginFailure(result.message ?? 'Login failed');
        }
        return LoginFailure('Unknown error');
      },
      onError: (e, _) {
        AppLogger.showLog('Bloc Login Error: $e');
        return LoginFailure('Login failed: $e');
      },
    );
  } catch (e) {
    AppLogger.showLog('Bloc Login Catch Error: $e');
    emit(LoginFailure('Unexpected error: $e'));
  }
}

  
  
}
