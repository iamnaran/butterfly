import 'package:bloc/bloc.dart';
import 'package:butterfly/core/database/entity/post/post_entity.dart';
import 'package:butterfly/core/repository/post/post_repository.dart';
import 'package:equatable/equatable.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  
  final IPostRepository _postRepository;

  PostBloc(this._postRepository) : super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());

    await emit.forEach(
      _postRepository.getAllProducts(),
      onData: (resource) {
        if (resource.isSuccess) {
          return PostLoaded(resource.data ?? []);
        } else if (resource.isFailed) {
          return PostError(resource.error.toString());
        } else {
          return PostLoading();
        }
      },
      onError: (error, _) => PostError(error.toString()),
    );
  }
}
