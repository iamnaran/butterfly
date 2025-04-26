import 'package:butterfly/core/database/entity/user/user_entity.dart';
import 'package:hive/hive.dart';

class UserDatabaseManager {

  static const String _userBoxName = 'usersBox';

  Future<Box<UserEntity>> get _userBox async =>
      await Hive.openBox<UserEntity>(_userBoxName);

  /// Saves a single user to the database.
  Future<void> saveUser(UserEntity user) async {
    final box = await _userBox;
    await box.put(user.id, user);
  }

  Future<UserEntity?> getUser(int id) async {
    final box = await _userBox;
    final userEntity = box.get(id);
    return userEntity;
  }

   Future<UserEntity?> getFirstAndOnlyUser() async {
    final box = await _userBox;
    if (box.length == 1) {
      return box.values.first;
    }
    return null;
  }

  Future<bool> containsAnyUser() async {
    final box = await _userBox;
    return box.isNotEmpty;
  }


  Future<void> deleteUser(int id) async {
    final box = await _userBox;
    await box.delete(id);
  }

  Future<void> deleteAllUsers() async {
    final box = await _userBox;
    await box.clear();
  }

  Future<bool> isUserExists(int id) async {
    final box = await _userBox;
    return box.containsKey(id);
  }

  /// Closes the user box.
  Future<void> closeUserBox() async {
    if (Hive.isBoxOpen(_userBoxName)) {
      await Hive.box<UserEntity>(_userBoxName).close();
    }
  }
}