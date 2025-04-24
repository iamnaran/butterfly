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

class ExploreRepositoryImpl extends IExploreRepository {
  final IApiServices networkapiservice;
  final ProductDatabaseManager _productDatabaseManager;

  ExploreRepositoryImpl(this.networkapiservice, this._productDatabaseManager);

  @override
  Stream<Resource<List<ProductEntity>>> getProductList() async* {
    final String url = Endpoints.getProducts();
    AppLogger.showError("Product List URL: $url");

    // 1. Load data from DB asynchronously if available
    yield Resource.loading(); // Emit loading state
    final initialData = await _productDatabaseManager.getAllProductEntities();
    yield Resource.success(data: initialData); // Emit initial DB data
    // print inital data
    // AppLogger.showError("Initial data from Hive: $initialData");

    try {
      final response = await networkapiservice.getGetApiResponse(url);
      if (response == null) {
        yield Resource.failed(error: Exception("No data received from API"));
        return;
      }
      final Map<String, dynamic> jsonMap = jsonDecode(response);
      final productApiResponse = ProductApiResponse.fromJson(jsonMap);
      final List<ProductEntity> fetchedProducts =
          ProductMapper.fromApiResponse(productApiResponse);
      _saveApiResult(fetchedProducts);

      yield Resource.success(data: fetchedProducts);
    } catch (e) {
      AppLogger.showError("Product List API Error: $e");
      yield Resource.failed(
          error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<void> _saveApiResult(List<ProductEntity> products) async {
    await _productDatabaseManager.saveProductEntityList(products);
    AppLogger.showError("Product list saved to Hive");
  }

}
