part of 'explore_bloc.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object> get props => [];
}

class FetchProductList extends ExploreEvent {
  const FetchProductList();
}