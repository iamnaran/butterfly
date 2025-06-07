import 'package:butterfly/data/remote/model/feeds/post_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'post_service.g.dart';

@RestApi()
abstract class PostService {
  factory PostService(Dio dio, {String baseUrl,     ParseErrorLogger? errorLogger,
}) = _PostService;

 @GET('/posts')
  Future<PostResponse> getPosts();
  
}