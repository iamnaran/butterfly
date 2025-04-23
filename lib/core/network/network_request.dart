import 'package:butterfly/core/network/base/resource.dart';

typedef FetchFromApi<T> = Future<T> Function();
typedef SaveResult<T> = Future<void> Function(T item);
typedef ShouldFetch<T> = bool Function(T? data);

class NetworkRequest<T> {
  final FetchFromApi<T> fetchFromApi;
  final SaveResult<T> saveApiResult;
  final ShouldFetch<T> shouldFetch;

  const NetworkRequest({
    required this.fetchFromApi,
    required this.saveApiResult,
    required this.shouldFetch,
  });

  Stream<Resource<T>> asStream(T? localData) async* {
    // Check if we should fetch new data from API
    if (shouldFetch(localData)) {
      yield Resource.loading(data: localData); // Show loading state

      try {
        // Fetch new data from API
        final remoteData = await fetchFromApi();
        
        // Save the API result to the database
        await saveApiResult(remoteData);

        // After successful fetch, yield the fetched data
        yield Resource.success(data: remoteData);
      } catch (e) {
        // Handle errors gracefully
        yield Resource.failed(error: e is Exception ? e : Exception(e.toString()), data: localData);
      }
    } else {
      // If no need to fetch, just emit local data (null or old data)
      yield Resource.success(data: localData);
    }
  }
}