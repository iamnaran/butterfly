import 'package:butterfly/network/status.dart';

class ApiResponse<T> {

  final T? data;
  final String? error;
  
  final ApiStatus apiStatus;

  ApiResponse(this.apiStatus, this.data, this.error);

  ApiResponse.loading() : apiStatus = ApiStatus.loading, data = null, error = null;
  ApiResponse.success(this.data) : apiStatus = ApiStatus.success, error = null;
  ApiResponse.failure(this.error) : apiStatus = ApiStatus.failure, data = null;
  ApiResponse.initial() : apiStatus = ApiStatus.initial, data = null, error = null;

  @override
  String toString() {
    return 'ApiResponse{data: $data, error: $error, apiStatus: $apiStatus}';
  }

}