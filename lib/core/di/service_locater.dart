
import 'package:butterfly/core/database/hive_db_manager.dart';
import 'package:butterfly/core/di/service_locater.config.dart';
import 'package:butterfly/core/network/services/api_services.dart';
import 'package:butterfly/core/network/services/api_services_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependenciesInjection() async => getIt.init();