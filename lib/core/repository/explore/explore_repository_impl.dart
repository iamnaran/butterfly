import 'dart:convert';

import 'package:butterfly/core/database/entity/explore/product_entity.dart';
import 'package:butterfly/core/database/hive_db_manager.dart';
import 'package:butterfly/core/model/explore/product_mapper.dart';
import 'package:butterfly/core/model/explore/product_response.dart';
import 'package:butterfly/core/network/network_bound.dart';
import 'package:butterfly/core/network/services/api_services.dart';
import 'package:butterfly/core/network/base/endpoints.dart';
import 'package:butterfly/core/network/base/resource.dart';
import 'package:butterfly/core/repository/explore/explore_repository.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IExploreRepository)
class ExploreRepositoryImpl extends IExploreRepository {
  final IApiServices networkapiservice;
  final HiveDbManager _hiveManager;

  ExploreRepositoryImpl(this.networkapiservice, this._hiveManager);

  @override
  Stream<Resource<List<ProductEntity>>> getProductList() {
    final String url = Endpoints.getProducts();
    AppLogger.showError("Product List URL: $url");

    return NetworkBoundResource<List<ProductEntity>>(
      loadFromDb: ()  {
        AppLogger.showError("Get from DB");

        return Stream.fromFuture(
            _hiveManager.getProductList().then((products) => products ?? []));
      },
      fetchFromApi: () async {
        AppLogger.showError("Product List Api Requested");
        try {
          final response = await networkapiservice.getGetApiResponse(url);
          AppLogger.showError("Product List API Response: $response");
          final Map<String, dynamic> jsonMap = jsonDecode(response);
          final productApiResponse = ProductApiResponse.fromJson(jsonMap);

          // Use the ProductMapper to convert API response data to entity list
          final List<ProductEntity> productEntityList = ProductMapper.fromApiResponse(productApiResponse);
          return productEntityList;
        } catch (e) {
          AppLogger.showError("Product List API Error: $e");
          throw Exception('Failed to fetch product list: $e');
        }
      },
      saveApiResult: (products) async {
        // Print type of each item in the products list
        for (var product in products) {
          AppLogger.showError("Item type: ${product.runtimeType}");
        }
        await _hiveManager.saveProductList(products);
        AppLogger.showError("Product list saved to Hive");
      },
      shouldFetch: (localData) {
        // Implement your logic for when to fetch from the API.
        // For example, you might check if the local data is old or doesn't exist.
        return true; // For now, always attempt to fetch on initial load
      },
    ).asStream();
  }
}
