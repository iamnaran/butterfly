import 'package:butterfly/network/Resource.dart';

typedef FetchFromApi<T> = Future<T> Function();
typedef ShouldFetch<T> = bool Function(T? data);

class NetworkApiRequest<T> {
  final FetchFromApi<T> fetchFromApi;
  final ShouldFetch<T> shouldFetch;

  const NetworkApiRequest({
    required this.fetchFromApi,
    required this.shouldFetch,
  });

  Stream<Resource<T>> asStream(T? localData) async* {
    // Show loading state while waiting for network data
    yield Resource.loading(data: localData);

    try {
      if (shouldFetch(localData)) {
        // Fetch new data from the network if needed
        final remoteData = await fetchFromApi();
        
        // Emit the fetched data with success
        yield Resource.success(data: remoteData);
      } else {
        // If no need to fetch data, just emit the local data as success
        yield Resource.success(data: localData);
      }
    } catch (e) {
      // Handle errors gracefully
      yield Resource.failed(error: e is Exception ? e : Exception(e.toString()), data: localData);
    }
  }
}