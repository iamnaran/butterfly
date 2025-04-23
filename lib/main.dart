import 'package:butterfly/core/database/hive_initalizer.dart';
import 'package:butterfly/core/di/service_locater.dart';
import 'package:butterfly/ui/auth/login_screen.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependenciesInjection();
  await initHive();
  AppLogger.configureLogging();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Butterfly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
