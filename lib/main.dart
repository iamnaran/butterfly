import 'package:butterfly/core/database/hive_initalizer.dart';
import 'package:butterfly/core/di/di_module.dart';
import 'package:butterfly/core/preference/pref_manager.dart';
import 'package:butterfly/navigation/router.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  await configureDependenciesInjection();
  final preferenceManager = getIt<PreferenceManager>();
  final bool loggedInStatus = preferenceManager.getLoggedIn();
  AppLogger.configureLogging();
  runApp(MyApp(isLoggedIn: loggedInStatus));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Butterfly',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.getRouter(isLoggedIn));
  }
}


// dart run build_runner build --delete-conflicting-outputs

