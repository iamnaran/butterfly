import 'dart:async';
import 'dart:convert';
import 'package:butterfly/core/database/entity/post/post_entity.dart';
import 'package:butterfly/core/database/manager/post_db_manager.dart';
import 'package:butterfly/core/model/feeds/post_mapper.dart';
import 'package:butterfly/core/model/feeds/post_response.dart';

import 'package:butterfly/core/network/base/endpoints.dart';
import 'package:butterfly/core/network/base/resource.dart';
import 'package:butterfly/core/network/services/api_services.dart';
import 'package:butterfly/core/repository/post/post_repository.dart';
import 'package:butterfly/utils/app_logger.dart';

class PostRepositoryImpl extends IPostRepository {
  final IApiServices networkapiservice;
  final PostDatabaseManager _postDatabaseManager;
  final StreamController<Resource<List<PostEntity>>> _postsController =
      StreamController.broadcast();
  bool _initialized = false;

  PostRepositoryImpl(this.networkapiservice, this._postDatabaseManager);

  @override
  Stream<Resource<List<PostEntity>>> getAllPosts() {
    if (!_initialized) {
      _init();
      _initialized = true;
    }
    return _postsController.stream;
  }

  void _init() async {
    final String url = Endpoints.getPosts();
    AppLogger.showError("Post List URL: $url");

    _postsController.add(Resource.loading());

    // 1. Emit initial data from DB
    final initialData = await _postDatabaseManager.getAllPosts();
    _postsController.add(Resource.success(data: initialData));

    // 2. Watch for DB changes
    _postDatabaseManager.watchPosts().listen((event) async {
      final updatedPosts = await _postDatabaseManager.getAllPosts();
      _postsController.add(Resource.success(data: updatedPosts));
    });

    try {
      final response = await networkapiservice.getGetApiResponse(url);
      if (response == null) {
        _postsController.add(
            Resource.failed(error: Exception("No data received from API")));
        return;
      }

      final Map<String, dynamic> jsonMap = jsonDecode(response);
      final postApiResponse = PostResponse.fromJson(jsonMap);
      final List<PostEntity> fetchedPosts =
          PostMapper.fromApiResponse(postApiResponse);
      _postsController.add(Resource.success(data: fetchedPosts));

      await _saveApiResult(fetchedPosts); // Save fetched posts to Hive
    } catch (e) {
      AppLogger.showError("Post List API Error: $e");
      _postsController.add(
          Resource.failed(error: e is Exception ? e : Exception(e.toString())));
    }
  }

  @override
  Future<Resource<PostEntity>> createPost(PostEntity createdPost) async {
    try {
      await _postDatabaseManager.savePost(createdPost);

      AppLogger.showError(
          "Post manually created and saved to Hive: ${createdPost.id}");

      return Resource.success(data: createdPost);
    } catch (e) {
      AppLogger.showError("Error while creating Post in Hive: $e");
      return Resource.failed(
          error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<void> _saveApiResult(List<PostEntity> posts) async {
    await _postDatabaseManager.savePostList(posts);
    AppLogger.showError("Post list saved to Hive");
  }
}
