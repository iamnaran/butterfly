import 'package:butterfly/data/remote/model/explore/product_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'explore_service.g.dart';

@RestApi()
abstract class ExploreService {
  factory ExploreService(Dio dio, {String baseUrl, ParseErrorLogger? errorLogger,
}) = _ExploreService;

   @GET('/products')
  Future<ProductApiResponse> getProducts();

  @GET('/product/{id}')
  Future<ProductData> getProductById(@Path('id') String id);

}