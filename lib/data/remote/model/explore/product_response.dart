import 'package:json_annotation/json_annotation.dart';

part 'product_response.g.dart';

@JsonSerializable()
class ProductApiResponse {
  final List<ProductData> products;
  final int total;
  final int skip;
  final int limit;

  ProductApiResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductApiResponseToJson(this);
}

@JsonSerializable()
class ProductData {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String>? images;

  ProductData({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    this.images,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDataToJson(this);
}
