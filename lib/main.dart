import 'package:butterfly/core/database/hive_db_manager.dart';
import 'package:butterfly/core/database/hive_initalizer.dart';
import 'package:butterfly/core/di/service_locater.dart';
import 'package:butterfly/navigation/router.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  await configureDependenciesInjection();
  final hive = getIt<HiveDbManager>();
  final loggedInStatus = await hive.getUserLoggedInStatus();
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

