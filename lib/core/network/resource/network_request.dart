import 'package:butterfly/core/network/resource/resource.dart';

typedef FetchFromApi<T> = Future<T> Function();
typedef SaveResult<T> = Future<void> Function(T item);
typedef ShouldFetch<T> = bool Function(T? data);

class NetworkRequest<T> {
  final FetchFromApi<T> fetchFromApi;
  final SaveResult<T> saveApiResult;

  const NetworkRequest({
    required this.fetchFromApi,
    required this.saveApiResult,
  });

  Stream<Resource<T>> asStream(T? localData) async* {
      yield Resource.loading(data: localData);
      try {
        final remoteData = await fetchFromApi();
        await saveApiResult(remoteData);
        yield Resource.success(data: remoteData);
      } catch (e) {
        yield Resource.failed(error: e is Exception ? e : Exception(e.toString()), data: localData);
      }
  }
}