part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  const ProfileLoaded({required this.user});
}

class ProfileLoggedOut extends ProfileState {}


class ProfileError extends ProfileState {
  final String message;
  const ProfileError({required this.message});
}
