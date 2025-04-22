// ignore_for_file: file_names
import 'package:butterfly/network/api_status.dart';

class Resource<T> {
  final ApiStatus status;
  final T? data;
  final String? message;
  final Exception? error;

  const Resource({
    required this.status,
    this.data,
    this.message,
    this.error,
  });

  factory Resource.loading({T? data, String? message}) {
    return Resource<T>(
      status: ApiStatus.loading,
      data: data,
      message: message,
    );
  }

  factory Resource.success({T? data, String? message}) {
    return Resource<T>(
      status: ApiStatus.success,
      data: data,
      message: message,
    );
  }

  factory Resource.failed({Exception? error, T? data, String? message}) {
    return Resource<T>(
      status: ApiStatus.failure,
      data: data,
      error: error,
      message: message ?? error?.toString(),
    );
  }

  bool get isLoading => status == ApiStatus.loading;
  bool get isSuccess => status == ApiStatus.success;
  bool get isFailed => status == ApiStatus.failure;
}