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

  factory ProductApiResponse.fromJson(Map<String, dynamic> json) {
    return ProductApiResponse(
      products: List<ProductData>.from(
        json['products'].map((e) => ProductData.fromJson(e)),
      ),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }
}

class ProductData {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;

  ProductData({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      discountPercentage: json['discountPercentage']?.toDouble() ?? 0.0,
      rating: json['rating']?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
    );
  }
}
