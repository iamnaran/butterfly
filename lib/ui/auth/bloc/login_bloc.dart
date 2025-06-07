import 'package:bloc/bloc.dart';
import 'package:butterfly/data/local/database/entity/user/user_entity.dart';
import 'package:butterfly/domain/usecases/auth/GetLoggedInUserUseCase.dart';
import 'package:butterfly/domain/usecases/auth/LoginRequestUseCase.dart';
import 'package:butterfly/domain/usecases/auth/LogoutUsecase.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final LoginRequestUseCase loginRequestUseCase;
  final LogoutUseCase logoutUseCase;
  final GetLoggedInUserUseCase getLoggedInUserUseCase;

   LoginBloc(this.loginRequestUseCase, this.logoutUseCase, this.getLoggedInUserUseCase)
      : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(LoginLoading());
      await emit.forEach(
        loginRequestUseCase(username: event.username, password: event.password),
        onData: (resource) {
          if (resource.isSuccess) {
            return LoginSuccess(resource.data!);
          } else if (resource.isFailed) {
            return LoginFailure(resource.error.toString());
          }else if (resource.isLoading) {
            return LoginLoading();
          }
          return LoginFailure('Unknown error');
        },
      );
    });

    on<LogoutRequested>((event, emit) {
      logoutUseCase();
      emit(LoggedOut());
    });

    on<CheckLoginStatus>((event, emit) async {
      final user = await getLoggedInUserUseCase();
      if (user != null) {
        emit(LoginSuccess(user));
      } else {
        emit(LoggedOut());
      }
    });
  }

  
  
}
