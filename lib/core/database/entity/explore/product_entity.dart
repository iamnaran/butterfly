import 'package:butterfly/core/database/entity/explore/dimension_entity.dart';
import 'package:butterfly/core/database/entity/explore/meta_entity.dart';
import 'package:butterfly/core/database/entity/explore/review_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../model/explore/product_response.dart';

part 'product_entity.g.dart';

@HiveType(typeId: 2)
class ProductEntity {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final double discountPercentage;

  @HiveField(6)
  final double rating;

  @HiveField(7)
  final int stock;

  @HiveField(8)
  final List<String> tags;

  @HiveField(9)
  final String brand;

  @HiveField(10)
  final String sku;

  @HiveField(11)
  final double weight;

  @HiveField(12)
  final DimensionEntity dimensions;

  @HiveField(13)
  final String warrantyInformation;

  @HiveField(14)
  final String shippingInformation;

  @HiveField(15)
  final String availabilityStatus;

  @HiveField(16)
  final List<ReviewEntity> reviews;

  @HiveField(17)
  final String returnPolicy;

  @HiveField(18)
  final int minimumOrderQuantity;

  @HiveField(19)
  final MetaEntity meta;

  @HiveField(20)
  final String thumbnail;

  @HiveField(21)
  final List<String> images;

  ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.thumbnail,
    required this.images,
  });

  factory ProductEntity.fromApiResponse(ProductData product) {
    return ProductEntity(
      id: product.id,
      title: product.title,
      description: product.description,
      category: product.category,
      price: product.price,
      discountPercentage: product.discountPercentage,
      rating: product.rating,
      stock: product.stock,
      tags: product.tags,
      brand: product.brand,
      sku: product.sku,
      weight: product.weight,
      // Mapping dimensions to DimensionEntity
      dimensions: DimensionEntity(
        width: product.dimensions.width,
        height: product.dimensions.height,
        depth: product.dimensions.depth,
      ),
      warrantyInformation: product.warrantyInformation,
      shippingInformation: product.shippingInformation,
      availabilityStatus: product.availabilityStatus,
      // Mapping reviews to a list of ReviewEntity
      reviews: product.reviews
          .map((review) => ReviewEntity(
        rating: review.rating,
        comment: review.comment,
        date: review.date,
        reviewerName: review.reviewerName,
        reviewerEmail: review.reviewerEmail,
      ))
          .toList(),
      returnPolicy: product.returnPolicy,
      minimumOrderQuantity: product.minimumOrderQuantity,
      // Mapping meta to MetaEntity
      meta: MetaEntity(
        createdAt: product.meta.createdAt,
        updatedAt: product.meta.updatedAt,
        barcode: product.meta.barcode,
        qrCode: product.meta.qrCode,
      ),
      thumbnail: product.thumbnail,
      images: List<String>.from(product.images),
    );
  }
}