part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostEvent {}



class CreatePost extends PostEvent {
  final PostEntity post;
  final Function(PostEntity post) onPostCreated;

  const CreatePost({required this.post, required this.onPostCreated});

  @override
  List<Object> get props => [post];
}