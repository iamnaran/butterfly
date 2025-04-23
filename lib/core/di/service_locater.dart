import 'package:butterfly/core/di/service_locater.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependenciesInjection() async => getIt.init();
