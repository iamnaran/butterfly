import 'package:butterfly/core/database/entity/post/post_entity.dart';
import 'package:hive/hive.dart';

class PostDatabaseManager {
  static const String _postBoxName = 'postsBox';

  // if inserted list in a single key [that will give some casting error]
  static const String _postListBoxName = '_postListBoxName';

  static const String _allPostsKey = 'allPosts'; // Define the key for the list

  Future<Box<List<PostEntity>>> get _postListBox async => // Box for a list
      await Hive.openBox<List<PostEntity>>(_postListBoxName);

  Future<Box<PostEntity>> get _postBox async =>
      await Hive.openBox<PostEntity>(_postBoxName);

  Stream<BoxEvent> watchPosts() async* {
    final box = await _postBox;
    yield* box.watch();
  }

  Future<void> savePost(PostEntity post) async {
    final box = await _postBox;
    await box.put(post.id, post);
  }

  Future<void> savePostList(List<PostEntity> posts) async {
    final box = await _postBox;
    final Map<int?, PostEntity> postMap = {
      for (var entity in posts) entity.id: entity
    };
    await box.putAll(postMap);
  }

  Future<void> savePostListToOneKey(List<PostEntity> posts) async {
    final box = await _postListBox;
    await box.put(_allPostsKey, posts); // Save the entire list under one key
  }

  Future<List<PostEntity>?> getAllPostsFromOneKey() async {
    final box = await _postListBox;
    return box.get(_allPostsKey); // Retrieve the entire list
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
