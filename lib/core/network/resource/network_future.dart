import 'package:butterfly/core/network/resource/network_request.dart';
import 'package:butterfly/core/network/resource/resource.dart';

class NetworkRequestFuture<T> {
  final FetchFromApi<T> fetchFromApi;
  final SaveResult<T> saveApiResult;

  const NetworkRequestFuture({
    required this.fetchFromApi,
    required this.saveApiResult,
  });

  Future<Resource<T>> execute() async {
    try {
      final remoteData = await fetchFromApi();
      await saveApiResult(remoteData);
      return Resource.success(data: remoteData);
    } catch (e) {
      return Resource.failed(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}