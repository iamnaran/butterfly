
import 'package:butterfly/data/local/database/entity/explore/product_entity.dart';
import 'package:butterfly/core/network/resource/resource.dart';

abstract class IExploreRepository {
    Stream<Resource<List<ProductEntity>>> getProductList();

    Stream<Resource<ProductEntity>> getProductById(String id);

}