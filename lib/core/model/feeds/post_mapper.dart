
import 'package:butterfly/core/database/entity/post/post_entity.dart';
import 'package:butterfly/core/model/feeds/post_response.dart';

class PostMapper {
  static List<PostEntity> fromApiResponse(PostResponse response) {
    return response.posts
        .where((post) => post.id != null)
        .map((post) => mapPostToEntity(post))
        .toList();
  }

  static PostEntity mapPostToEntity(Post post) {
    return PostEntity(
      id: post.id!,
      title: post.title ?? '',
      body: post.body ?? '',
      tags: post.tags ?? [],
      reactions: ReactionHiveModel(
        likes: post.reactions?.likes ?? 0,
        dislikes: post.reactions?.dislikes ?? 0,
      ),
      views: post.views ?? 0,
      userId: post.userId ?? 0,
    );
  }

  static Post mapEntityToPost(PostEntity entity) {
    return Post(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      tags: entity.tags,
      reactions: Reactions(
        likes: entity.reactions.likes,
        dislikes: entity.reactions.dislikes,
      ),
      views: entity.views,
      userId: entity.userId,
    );
  }
}