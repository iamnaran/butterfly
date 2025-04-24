import 'package:butterfly/core/database/entity/explore/product_entity.dart';
import 'package:butterfly/core/database/entity/user/user_entity.dart';
import 'package:butterfly/core/database/hive_constants.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class HiveDbManager {
  final Map<String, Box> _openBoxes = {};

  Future<Box<T>> _ensureOpenBox<T>(String boxName) async {
    if (_openBoxes.containsKey(boxName)) {
      return _openBoxes[boxName] as Box<T>;
    }
    final box = await Hive.openBox<T>(boxName);
    _openBoxes[boxName] = box;
    return box;
  }

  // User Box
  Future<Box<UserEntity>> _getUserBox() async {
    return await _ensureOpenBox<UserEntity>(HiveConstants.userBox);
  }

  Future<void> saveLoggedInUser(UserEntity user) async {
    final box = await _getUserBox();
    await box.put(HiveConstants.keyLoggedInUser, user);
  }

  Future<UserEntity?> getLoggedInUser() async {
    final box = await _getUserBox();
    return box.get(HiveConstants.keyLoggedInUser);
  }

  Future<void> clearLoggedInUser() async {
    final box = await _getUserBox();
    await box.delete(HiveConstants.keyLoggedInUser);
  }

  Future<bool> getUserLoggedInStatus() async {
    final user = await getLoggedInUser();
    return user != null;
  }

  // Product List Box
  Future<Box<List<ProductEntity>>> _getProductListBox() async {
    return await _ensureOpenBox<List<ProductEntity>>(HiveConstants.productBox);
  }

  Future<void> saveProductList(List<ProductEntity> products) async {
    final box = await _getProductListBox();
    await box.put(HiveConstants.keyProductList, products);
    AppLogger.showError(
        "Product list saved to Hive: ${box.get(HiveConstants.keyProductList)}");
  }

  Future<List<ProductEntity>?> getProductList() async {
    final box = await _getProductListBox();
  
    AppLogger.showError("Get Product Box has value AAAA");
    
    return box.get(HiveConstants.keyProductList);
  }

  Stream<List<ProductEntity>?> getProductListStream() async* {
    final box = await _getProductListBox();
    final stream = box.watch(key: HiveConstants.keyProductList);
    yield box.get(HiveConstants.keyProductList);
    yield* stream.map((event) => box.get(HiveConstants.keyProductList));
  }

  Future<void> clearProductList() async {
    final box = await _getProductListBox();
    await box.delete(HiveConstants.keyProductList);
  }
}
