import 'package:bloc/bloc.dart';
import 'package:butterfly/core/database/entity/user/user_entity.dart';
import 'package:butterfly/core/repository/auth/auth_repository.dart';
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

      if (result.isSuccess && result.data != null) {
        emit(LoginSuccess(result.data!));
      } else {
        emit(LoginFailure(result.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(LoginFailure('Login failed: $e'));
    }
  }

  
  
}
