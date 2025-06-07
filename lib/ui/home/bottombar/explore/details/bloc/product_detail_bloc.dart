import 'package:bloc/bloc.dart';
import 'package:butterfly/data/local/database/entity/explore/product_entity.dart';
import 'package:butterfly/core/network/resource/api_status.dart';
import 'package:butterfly/core/network/resource/resource.dart';
import 'package:butterfly/data/repository/explore/explore_repository.dart';
import 'package:equatable/equatable.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final IExploreRepository _exploreRepository;

  ProductDetailBloc(this._exploreRepository) : super(ProductDetailInitial()) {
    on<FetchProductDetail>(
        _onFetchProductDetail); // Directly register the specific event handler
  }

  Future<void> _onFetchProductDetail(
    FetchProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading(null)); // Emit initial loading state

    await emit.forEach<Resource<ProductEntity>>(
      _exploreRepository.getProductById(event.productId.toString()),
      onData: (resource) {
        switch (resource.status) {
          case ApiStatus.initial:
            return ProductDetailInitial();
          case ApiStatus.loading:
            return ProductDetailLoading(
              (state is ProductDetailLoaded)
                  ? (state as ProductDetailLoaded).product
                  : null,
            );
          case ApiStatus.success:
            return ProductDetailLoaded(product: resource.data!);
          case ApiStatus.failure:
            return ProductDetailError(
                resource.message ?? 'Failed to load product details');
        }
      },
      onError: (error, _) {
        return ProductDetailError('Unexpected error occurred: $error');
      },
    );
  }
}
