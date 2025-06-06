import 'package:bloc/bloc.dart';
import 'package:butterfly/core/database/entity/explore/product_entity.dart';
import 'package:butterfly/core/network/resource/api_status.dart';
import 'package:butterfly/core/repository/explore/explore_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/network/resource/resource.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final IExploreRepository _exploreRepository;

  ExploreBloc(this._exploreRepository) : super(ExploreInitial()) {
    on<FetchProductList>(_onFetchProductList);
  }

  Future<void> _onFetchProductList(
      FetchProductList event,
      Emitter<ExploreState> emit,
      ) async {
    emit(ProductListLoading());

    await emit.forEach<Resource<List<ProductEntity>>>(
      _exploreRepository.getProductList(),
      onData: (resource) {
        switch (resource.status) {
          case ApiStatus.initial:
            return state;

          case ApiStatus.loading:
            if (state is! ProductListLoading) {
              return ProductListLoading(
                previousProducts:
                (state is ProductListLoaded) ? (state as ProductListLoaded).products : null,
              );
            }
            return state;

          case ApiStatus.success:
            return ProductListLoaded(products: resource.data ?? []);

          case ApiStatus.failure:
            return ProductListError(message: resource.message ?? 'Failed to load products');
        }
      },
      onError: (error, _) {
        return ProductListError(message: 'Unexpected error occurred $error');
      },
    );
  }
}
