part of 'product_detail_bloc.dart';

sealed class ProductDetailState extends Equatable {
  const ProductDetailState();
  
  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {
  final ProductEntity? previousProduct;

  const ProductDetailLoading(this.previousProduct);

  @override
  List<Object> get props => [previousProduct ?? 'null'];
}

class ProductDetailLoaded extends ProductDetailState {
  final ProductEntity product;

  const ProductDetailLoaded({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object> get props => [message];
}