import 'package:butterfly/core/database/entity/user/user_entity.dart';
import 'package:butterfly/core/database/hive_constants.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class HiveDbManager {

  final Map<String, Box> _openBoxes = {};

  // Open a box dynamically based on its name
  Future<Box<T>> _openBox<T>(String boxName) async {
    if (_openBoxes.containsKey(boxName)) {
      return _openBoxes[boxName] as Box<T>;
    }
    final box = await Hive.openBox<T>(boxName);
    _openBoxes[boxName] = box;
    return box;
  }

  // Generic method to delete an item

  Future<void> saveItem<T>(String boxName, String key, T item) async {
    final box = await _openBox<T>(boxName);
    await box.put(key, item);
  }

  Future<T?> getItem<T>(String boxName, String key) async {
    final box = await _openBox<T>(boxName);
    return box.get(key);
  }

  Future<void> clearItem<T>(String boxName, String key) async {
    final box = await _openBox<T>(boxName);
    await box.delete(key);
  }

  Future<bool> itemExists<T>(String boxName, String key) async {
    final box = await _openBox<T>(boxName);
    return box.containsKey(key);
  }

  // User Box
  Future<void> saveLoggedInUser(UserEntity user) async {
    await saveItem<UserEntity>(HiveConstants.userBox, HiveConstants.keyLoggedInUser, user);
  }

  Future<UserEntity?> getLoggedInUser() async {
    return await getItem<UserEntity>(HiveConstants.userBox, HiveConstants.keyLoggedInUser);
  }

  Future<void> clearLoggedInUser() async {
    await clearItem<UserEntity>(HiveConstants.userBox, HiveConstants.keyLoggedInUser);
  }

  // Save the login status
  Future<void> saveUserLoggedInStatus(bool isLoggedIn) async {
    await saveItem<bool>(HiveConstants.userBox, HiveConstants.keyIsUserLoggedIn, isLoggedIn);
  }

  // Get the login status
  Future<bool?> getUserLoggedInStatus() async {
    return await getItem<bool>(HiveConstants.userBox, HiveConstants.keyIsUserLoggedIn);
  }


}