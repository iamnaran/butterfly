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
    try {
      await for (final localData in loadFromDb()) {
        yield Resource.success(data: localData);
        break; 
      }

      final currentDbData = await loadFromDb().first;

      if (shouldFetch(currentDbData)) {
        // Show loading with DB data fallback
        yield Resource.loading(data: currentDbData);

        try {
          final apiData = await fetchFromApi();
          await saveApiResult(apiData);

          // Emit the updated DB data after saving
          await for (final updatedDb in loadFromDb()) {
            yield Resource.success(data: updatedDb);
            break; // Emit updated result once
          }

        } catch (e) {
          yield Resource.failed(
            error: e is Exception ? e : Exception(e.toString()),
            data: currentDbData,
          );
        }
      }

    } catch (e) {
      yield Resource.failed(
        error: e is Exception ? e : Exception(e.toString()),
        data: null,
      );
    }
  }
}