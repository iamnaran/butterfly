import 'dart:convert';

import 'package:butterfly/core/database/manager/product_db_manager.dart';
import 'package:butterfly/core/database/entity/explore/product_entity.dart';
import 'package:butterfly/core/model/explore/product_mapper.dart';
import 'package:butterfly/core/model/explore/product_response.dart';
import 'package:butterfly/core/network/services/api_services.dart';
import 'package:butterfly/core/network/base/endpoints.dart';
import 'package:butterfly/core/network/base/resource.dart';
import 'package:butterfly/core/repository/explore/explore_repository.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

class ExploreRepositoryImpl extends IExploreRepository {
  final IApiServices networkapiservice;
  final ProductDatabaseManager _productDatabaseManager;

  ExploreRepositoryImpl(this.networkapiservice, this._productDatabaseManager);

  @override
  Stream<Resource<List<ProductEntity>>> getProductList() async* {
    final String url = Endpoints.getProducts();
    yield Resource.loading(); // Emit loading state
    final initialData = await _productDatabaseManager.getAllProductEntities();
    yield Resource.success(data: initialData); // Emit initial DB data
    try {
      final response = await networkapiservice.getGetApiResponse(url);
      final Map<String, dynamic> jsonMap = jsonDecode(response);
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
    final String url = Endpoints.getProductDetails(id);
    yield Resource.loading(); // Emit loading state
    try {
      final initialData = await _productDatabaseManager.getProductEntity(int.parse(id));
      yield Resource.success(data: initialData); 
      final response = await networkapiservice.getGetApiResponse(url);
      final Map<String, dynamic> jsonMap = jsonDecode(response);
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
