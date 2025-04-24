import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  void setIndex(int index) => emit(index);
}