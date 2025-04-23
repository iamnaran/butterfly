part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

class LogoutInitial extends HomeState {}

class LogoutInProgress extends HomeState {}

class LogoutSuccess extends HomeState {}

class LogoutFailure extends HomeState {
  final String message;
  const LogoutFailure(this.message);
}