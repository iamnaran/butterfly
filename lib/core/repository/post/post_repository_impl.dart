import 'dart:convert';

import 'package:butterfly/core/database/entity/post/post_entity.dart';
import 'package:butterfly/core/database/manager/post_db_manager.dart';
import 'package:butterfly/core/model/feeds/post_mapper.dart';
import 'package:butterfly/core/model/feeds/post_response.dart';
import 'package:butterfly/core/network/resource/endpoints.dart';
import 'package:butterfly/core/network/resource/resource.dart';
import 'package:butterfly/core/network/services/post/post_service.dart';
import 'package:butterfly/core/repository/post/post_repository.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

class PostRepositoryImpl extends IPostRepository {
  final PostService _postService;
  final PostDatabaseManager _postDatabaseManager;

  PostRepositoryImpl(this._postService, this._postDatabaseManager);

  @override
  Stream<Resource<List<PostEntity>>> getAllPosts() async* {
    final String url = Endpoints.getPosts();
    AppLogger.showError("Post List URL: $url");

    // 1. Load data from DB asynchronously if available
    yield Resource.loading(); // Emit loading state
    final initialData = await _postDatabaseManager.getAllPosts();
    yield Resource.success(data: initialData); // Emit initial DB data
    try {
      final response = await _postService.getPosts();
      if (response.toString().isNotEmpty) {
        yield Resource.failed(error: Exception("No data received from API"));
        return;
      }
      final Map<String, dynamic> jsonMap = jsonDecode(response.toString());
      final postApiResponse = PostResponse.fromJson(jsonMap);
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
      // Create a new PostEntity with default/mock values

      // Save the new post into Hive
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
    // await _postDatabaseManager.savePostList(posts);
    await _postDatabaseManager.savePostList(posts);

    AppLogger.showError("Post list saved to Hive");
  }
}
