
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? 'https://defaulturl.com/api';  // Fallback URL if .env fails

  // Auth Endpoints
  static String login() => '$_baseUrl/login';
  static String register() => '$_baseUrl/register';

  // User Endpoints
  static String getUserProfile(String userId) => '$_baseUrl/user/$userId';
  static String updateUserProfile(String userId) => '$_baseUrl/user/$userId/update';

  // Product Endpoints
  static String getProducts() => '$_baseUrl/products';
  static String getProductDetails(String productId) => '$_baseUrl/products/$productId';
  
}