
import 'package:butterfly/core/network/resource/resource.dart';
import 'package:butterfly/data/local/database/entity/explore/product_entity.dart';
import 'package:butterfly/data/repository/explore/explore_repository.dart';

class GetProductListUseCase {
  final IExploreRepository _repository;

  GetProductListUseCase(this._repository);

  Stream<Resource<List<ProductEntity>>> call() {
    return _repository.getProductList();
  }
}