import 'package:butterfly/core/network/base/resource.dart';

typedef FetchFromApi<T> = Future<T> Function();
typedef SaveResult<T> = Future<void> Function(T item);
typedef LoadFromDb<T> = Stream<T> Function();
typedef ShouldFetch<T> = bool Function(T? data);

class NetworkBoundResource<T> {
  final LoadFromDb<T> loadFromDb;
  final FetchFromApi<T> fetchFromApi;
  final SaveResult<T> saveApiResult;
  final ShouldFetch<T> shouldFetch;

  const NetworkBoundResource({
    required this.loadFromDb,
    required this.fetchFromApi,
    required this.saveApiResult,
    required this.shouldFetch,
  });

  Stream<Resource<T>> asStream() async* {
    // Start by yielding the current database data
    yield* loadFromDb().asyncExpand((localData) async* {
      // Check if we should fetch new data from API
      if (shouldFetch(localData)) {
        yield Resource.loading(data: localData); // Show loading state
        
        try {
          // Fetch new data from API
          final remoteData = await fetchFromApi();
          
          // Save the API result to the database
          await saveApiResult(remoteData);
          
          // After successful fetch, load updated data from the DB
          yield* loadFromDb().map((updatedDb) => Resource.success(data: updatedDb));
        } catch (e) {
          // Handle errors gracefully
          yield Resource.failed(error: e is Exception ? e : Exception(e.toString()), data: localData);
        }
      } else {
        // If no need to fetch, just emit local data
        yield Resource.success(data: localData);
      }
    });
  }
}