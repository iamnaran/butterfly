import 'package:bloc/bloc.dart';
import 'package:butterfly/core/database/hive_db_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final HiveDbManager hiveDbManager;


  HomeBloc(this.hiveDbManager) : super(HomeInitial()) {
      on<LogoutUser>((event, emit) async {
        hiveDbManager.clearLoggedInUser();
        emit(LogoutSuccess());
      });
    }

}
