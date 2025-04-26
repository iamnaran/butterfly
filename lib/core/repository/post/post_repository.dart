import 'package:butterfly/core/database/entity/post/post_entity.dart';
import 'package:butterfly/core/network/base/resource.dart';

abstract class IPostRepository {
    Stream<Resource<List<PostEntity>>> getAllPosts();
    Future<Resource<PostEntity>> createPost(PostEntity post);
}