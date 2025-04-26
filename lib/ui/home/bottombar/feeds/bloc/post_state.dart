part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();
  
  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostEntity> posts;

  const PostLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object> get props => [message];
}

class PostCreating extends PostState {
  final PostEntity post;

  const PostCreating({required this.post});

  @override
  List<Object> get props => [post];
}

class PostCreated extends PostState {}

class PostCreatingError extends PostState {
  final String message;

  const PostCreatingError(this.message);

  @override
  List<Object> get props => [message];
}
