import 'package:butterfly/core/database/entity/explore/product_entity.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDatabaseManager {
  static const String _productBoxName = 'products';

  Future<Box<ProductEntity>> get _productBox async =>
      await Hive.openBox<ProductEntity>(_productBoxName);

  Future<void> saveProductEntity(ProductEntity product) async {
    final box = await _productBox;
    await box.put(product.id, product);
  }

Future<void> saveProductEntityList(List<ProductEntity> products) async {
    final box = await _productBox;
    final Map<int, ProductEntity> productMap =
        {for (var entity in products) entity.id: entity};
    await box.putAll(productMap);
  }

  Future<ProductEntity?> getProductEntity(int id) async {
    final box = await _productBox;
    return box.get(id);
  }

Future<List<ProductEntity>> getAllProductEntities() async {
  final box = await _productBox;
  return box.values.toList();
}
  /// Deletes a single product from the database by its ID.
  Future<void> deleteProduct(int id) async {
    final box = await _productBox;
    await box.delete(id);
  }

  /// Deletes all products from the database. Use with caution!
  Future<void> deleteAllProducts() async {
    final box = await _productBox;
    await box.clear();
  }

  /// Checks if a product with the given ID exists in the database.
  Future<bool> isProductExists(int id) async {
    final box = await _productBox;
    return box.containsKey(id);
  }

  /// Closes the product box. It's good practice to close boxes when they are no longer needed.
  Future<void> closeProductBox() async {
    if (Hive.isBoxOpen(_productBoxName)) {
      await Hive.box<ProductEntity>(_productBoxName).close();
    }
  }
}