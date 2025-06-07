part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends LoginEvent {
  final String username;
  final String password;

  const LoginRequested({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}


// Trigger logout
class LogoutRequested extends LoginEvent {
  const LogoutRequested();
}

// Check login status on app start
class CheckLoginStatus extends LoginEvent {
  const CheckLoginStatus();
}
