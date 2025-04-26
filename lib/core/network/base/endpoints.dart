class Endpoints {
  static final String _baseUrl = 'https://dummyjson.com';
// 'https://dummyjson.com/auth/login'

  // Auth Endpoints
  static String login() => '$_baseUrl/auth/login';
  static String register() => '$_baseUrl/auth/register';

  // User Endpoints
  static String getUserProfile(String userId) => '$_baseUrl/auth/me/$userId';

  // Product Endpoints
  static String getProducts() => '$_baseUrl/products';
  static String getProductDetails(String productId) => '$_baseUrl/products/$productId';

  // Post Endpoints
  static String getPosts() => '$_baseUrl/posts';
  static String createPost() => '$_baseUrl/posts/add';
  static String getPostDetails(String postId) => '$_baseUrl/posts/$postId';
  static String deletePost(String postId) => '$_baseUrl/posts/$postId';

  
}