import 'package:bloc/bloc.dart';
import 'package:butterfly/core/database/entity/post/post_entity.dart';
import 'package:butterfly/core/repository/post/post_repository.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:equatable/equatable.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final IPostRepository _postRepository;

  PostBloc(this._postRepository) : super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<CreatePost>(_onCreatePost);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    
  emit(PostLoading());

    await emit.forEach(
      _postRepository.getAllPosts(),
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

  Future<void> _onCreatePost(
    CreatePost event,
    Emitter<PostState> emit,
  ) async {
    // Emit creating state
    emit(PostCreating(post: event.post));

    try {
      final result = await _postRepository.createPost(event.post);

      if (result.data != null) {
        // Emit post created state
        emit(PostCreated());
        event.onPostCreated(result.data!); // Callback to UI with created post
      } else {
        // In case of error, emit error state
        emit(PostCreatingError('Failed to create post'));
        AppLogger.showError('Failed to create post: ${result.error}');
      }
    } catch (error) {
      emit(PostCreatingError('Failed to create post: $error'));
      AppLogger.showError('Error while creating post: $error');
    }
  }
}
