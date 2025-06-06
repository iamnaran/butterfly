import 'dart:convert';

import 'package:butterfly/core/database/manager/product_db_manager.dart';
import 'package:butterfly/core/database/entity/explore/product_entity.dart';
import 'package:butterfly/core/model/explore/product_mapper.dart';
import 'package:butterfly/core/model/explore/product_response.dart';
import 'package:butterfly/core/network/resource/resource.dart';
import 'package:butterfly/core/network/services/explore/explore_service.dart';
import 'package:butterfly/core/repository/explore/explore_repository.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

class ExploreRepositoryImpl extends IExploreRepository {
  final ExploreService _exploreService;
  final ProductDatabaseManager _productDatabaseManager;

  ExploreRepositoryImpl(this._exploreService, this._productDatabaseManager);

  @override
  Stream<Resource<List<ProductEntity>>> getProductList() async* {
    yield Resource.loading();
    final initialData = await _productDatabaseManager.getAllProductEntities();
    yield Resource.success(data: initialData);
    try {
      final response = await _exploreService.getProducts();
      final Map<String, dynamic> jsonMap = jsonDecode(response.toString());
      final productApiResponse = ProductApiResponse.fromJson(jsonMap);
      final List<ProductEntity> fetchedProducts =
          ProductMapper.fromApiResponse(productApiResponse);
      _saveApiResult(fetchedProducts);

      if (!listEquals(fetchedProducts, initialData)) {
        yield Resource.success(data: fetchedProducts);
      }
    } catch (e) {
      AppLogger.showError("Product List API Error: $e");
      yield Resource.failed(
          error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<void> _saveApiResult(List<ProductEntity> products) async {
    await _productDatabaseManager.saveProductEntityList(products);
  }

  @override
  Stream<Resource<ProductEntity>> getProductById(String id) async* {
    yield Resource.loading(); 
    try {
      final initialData = await _productDatabaseManager.getProductEntity(int.parse(id));
      yield Resource.success(data: initialData); 
      final response = await _exploreService.getProductById(id);
      final Map<String, dynamic> jsonMap = jsonDecode(response.toString());
      final productApiResponse = ProductData.fromJson(jsonMap);
      final ProductEntity fetchedProduct =
          ProductMapper.fromApiProductData(productApiResponse);
      yield Resource.success(data: fetchedProduct);
    } catch (e) {
      AppLogger.showError("Product API Error: $e");
      yield Resource.failed(
          error: e is Exception ? e : Exception(e.toString()));
    }
  }

}
