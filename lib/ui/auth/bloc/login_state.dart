part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user; 

  const LoginSuccess(this.user);

  @override
  List<Object> get props => [user.id, user.username, user.email];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}

class LoggedOut extends LoginState {
  const LoggedOut();
}