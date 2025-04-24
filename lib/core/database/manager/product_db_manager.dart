import 'package:butterfly/core/database/entity/explore/product_entity.dart';
import 'package:hive/hive.dart';

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
  Future<void> deleteProduct(int id) async {
    final box = await _productBox;
    await box.delete(id);
  }

  Future<void> deleteAllProducts() async {
    final box = await _productBox;
    await box.clear();
  }

  Future<bool> isProductExists(int id) async {
    final box = await _productBox;
    return box.containsKey(id);
  }

  Future<void> closeProductBox() async {
    if (Hive.isBoxOpen(_productBoxName)) {
      await Hive.box<ProductEntity>(_productBoxName).close();
    }
  }
}