import 'package:butterfly/core/repository/auth_repository.dart';
import 'package:butterfly/ui/auth/bloc/login_event.dart';
import 'package:butterfly/ui/auth/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<LoginRequestEvent>(_onLoginRequest);
  }

  Future<void> _onLoginRequest(
    LoginRequest event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      
     
    } catch (e) {
      emit(LoginFailure("Unexpected error: ${e.toString()}"));
    }
  }
  
}