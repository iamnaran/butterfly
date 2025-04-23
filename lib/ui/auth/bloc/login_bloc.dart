import 'package:bloc/bloc.dart';
import 'package:butterfly/core/database/entity/user/user_entity.dart';
import 'package:butterfly/core/network/base/api_status.dart';
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
      final responseStream = authRepository.login(event.username, event.password);
      final result = await responseStream.first;
      AppLogger.showLog('Login result: ${result.status.toString()}');
      if (result.status == ApiStatus.loading) {
        emit(LoginLoading());
      } else if (result.status == ApiStatus.failure) {
        emit(LoginFailure(result.message ?? 'Login failed from Bloc'));
      } else if (result.status == ApiStatus.success) {
        emit(LoginSuccess(result.data!));
      }
    } catch (e) {
      emit(LoginFailure('Login failed from error : $e'));
    }
  }

  
  
}
