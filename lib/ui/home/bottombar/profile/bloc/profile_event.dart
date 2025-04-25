part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  final int userId; 
  const LoadProfileEvent({required this.userId});
}


class LogoutEvent extends ProfileEvent {}

