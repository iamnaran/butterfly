import 'package:butterfly/data/local/database/entity/post/post_entity.dart';
import 'package:butterfly/core/network/resource/resource.dart';

abstract class IPostRepository {
    Stream<Resource<List<PostEntity>>> getAllPosts();
    Future<Resource<PostEntity>> createPost(PostEntity post);
}