import 'package:butterfly/data/local/database/entity/post/post_entity.dart';
import 'package:butterfly/data/local/database/manager/post_db_manager.dart';
import 'package:butterfly/data/remote/model/feeds/post_mapper.dart';
import 'package:butterfly/core/network/resource/resource.dart';
import 'package:butterfly/core/network/services/post/post_service.dart';
import 'package:butterfly/data/repository/post/post_repository.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

class PostRepositoryImpl extends IPostRepository {
  final PostService _postService;
  final PostDatabaseManager _postDatabaseManager;

  PostRepositoryImpl(this._postService, this._postDatabaseManager);

  @override
  Stream<Resource<List<PostEntity>>> getAllPosts() async* {
    // 1. Load data from DB asynchronously if available
    yield Resource.loading(); // Emit loading state
    final initialData = await _postDatabaseManager.getAllPosts();
    yield Resource.success(data: initialData); // Emit initial DB data
    try {
      final postApiResponse = await _postService.getPosts();
      final List<PostEntity> fetchedPosts =
          PostMapper.fromApiResponse(postApiResponse);
      _saveApiResult(fetchedPosts);

      if (!listEquals(fetchedPosts, initialData)) {
        yield Resource.success(data: fetchedPosts);
      }
    } catch (e) {
      AppLogger.showError("Post List API Error: $e");
      yield Resource.failed(
          error: e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Resource<PostEntity>> createPost(PostEntity createdPost) async {
    try {
      await _postDatabaseManager.savePost(createdPost);
      return Resource.success(data: createdPost);
    } catch (e) {
      return Resource.failed(
          error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<void> _saveApiResult(List<PostEntity> posts) async {
    // await _postDatabaseManager.savePostList(posts);
    await _postDatabaseManager.savePostList(posts);

    AppLogger.showError("Post list saved to Hive");
  }
}
