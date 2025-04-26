import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AppCacheManager {
  // create constant for cache key
  static const String appCacheKey = 'app_image_cache';

  static CacheManager instance = CacheManager(
    Config(
      appCacheKey, 
      maxNrOfCacheObjects: 200, 
      stalePeriod: const Duration(days: 7), 
    ),
  );
}
