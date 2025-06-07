import 'package:bloc/bloc.dart';
import 'package:butterfly/data/local/database/entity/explore/product_entity.dart';
import 'package:butterfly/domain/usecases/explore/GetProductListUseCase.dart';
import 'package:butterfly/domain/usecases/explore/GetProductsByIdUseCase.dart';
import 'package:equatable/equatable.dart';


part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetProductListUseCase getProductListUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;

ExploreBloc(this.getProductListUseCase, this.getProductByIdUseCase)
      : super(ExploreInitial()) {
    on<FetchProductList>(_onFetchProductList);
  }

  Future<void> _onFetchProductList(FetchProductList event, Emitter<ExploreState> emit) async {
    emit(ProductListLoading());
    await emit.forEach(
      getProductListUseCase(),
      onData: (resource) {
        if (resource.isSuccess) {
          return ProductListLoaded(products: resource.data ?? []);
        } else if (resource.isFailed) {
          return ProductListError(
            message: resource.message ?? 'Failed to load products',
          );
        } else if (resource.isLoading) {
          return ProductListLoading(
            previousProducts: (state is ProductListLoaded)
                ? (state as ProductListLoaded).products
                : null,
          );
        }
        return ProductListLoading();
      },
    );
  }
}
