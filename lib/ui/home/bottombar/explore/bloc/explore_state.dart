part of 'explore_bloc.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object> get props => [];
}

class ExploreInitial extends ExploreState {}

class ProductListLoading extends ExploreState {
  final List<ProductEntity>? previousProducts;

  const ProductListLoading({this.previousProducts});

  @override
  List<Object> get props => [previousProducts ?? []];
}

class ProductListLoaded extends ExploreState {
  final List<ProductEntity> products;

  const ProductListLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductListError extends ExploreState {
  final String message;

  const ProductListError({required this.message});

  @override
  List<Object> get props => [message];
}
