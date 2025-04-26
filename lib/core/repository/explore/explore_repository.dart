
import 'package:butterfly/core/database/entity/explore/product_entity.dart';
import 'package:butterfly/core/network/base/resource.dart';

abstract class IExploreRepository {
    Stream<Resource<List<ProductEntity>>> getProductList();

    Stream<Resource<ProductEntity>> getProductById(String id);

}