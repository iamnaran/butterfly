import 'package:butterfly/core/network/resource/resource.dart';
import 'package:butterfly/data/local/database/entity/explore/product_entity.dart';
import 'package:butterfly/data/repository/explore/explore_repository.dart';

class GetProductByIdUseCase {
  final IExploreRepository _repository;

  GetProductByIdUseCase(this._repository);

  Stream<Resource<ProductEntity>> call(String id) {
    return _repository.getProductById(id);
  }
}