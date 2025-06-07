import 'package:butterfly/data/local/database/entity/explore/product_entity.dart';
import 'package:butterfly/data/remote/model/explore/product_response.dart';

class ProductMapper {
  static List<ProductEntity> fromApiResponse(ProductApiResponse response) {
    return response.products.map((product) {
      return ProductEntity.fromApiResponse(product);
    }).toList();
  }

  static ProductEntity fromApiProductData(ProductData product) {
    return ProductEntity.fromApiResponse(product);
  }
}