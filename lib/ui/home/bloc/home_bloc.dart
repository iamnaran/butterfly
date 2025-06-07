import 'package:bloc/bloc.dart';
import 'package:butterfly/data/repository/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final IAuthRepository _authRepository;

  HomeBloc(this._authRepository) : super(HomeInitial()) {
      on<LogoutUser>((event, emit) async {
        _authRepository.logout();
        emit(LogoutSuccess());
      });
    }

}
