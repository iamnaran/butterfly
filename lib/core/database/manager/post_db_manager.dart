import 'package:butterfly/core/database/entity/post/post_entity.dart';
import 'package:hive/hive.dart';

class PostDatabaseManager {
  static const String _postBoxName = 'posts';

  Future<Box<PostEntity>> get _postBox async => await Hive.openBox<PostEntity>(_postBoxName);

  Future<void> savePost(PostEntity post) async {
    final box = await _postBox;
    await box.put(post.id, post); 
  }

  Future<void> savePostList(List<PostEntity> posts) async {
    final box = await _postBox;
    final Map<int?, PostEntity> postMap =
        {for (var entity in posts) entity.id: entity};
    await box.putAll(postMap);
  }

  Future<PostEntity?> getPost(int id) async {
    final box = await _postBox;
    return box.get(id);
  }

  Future<List<PostEntity>> getAllPosts() async {
    final box = await _postBox;
    return box.values.toList();
  }

  Future<void> deletePost(int id) async {
    final box = await _postBox;
    await box.delete(id);
  }

  Future<void> deleteAllPosts() async {
    final box = await _postBox;
    await box.clear();
  }

  Future<bool> isPostExists(int id) async {
    final box = await _postBox;
    return box.containsKey(id);
  }

  Future<void> closePostBox() async {
    if (Hive.isBoxOpen(_postBoxName)) {
      await Hive.box<PostEntity>(_postBoxName).close();
    }
  }
}