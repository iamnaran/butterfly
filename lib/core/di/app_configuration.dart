import 'package:butterfly/core/di/bloc_injection.dart';
import 'package:butterfly/core/di/db_injection.dart';
import 'package:butterfly/core/di/mqtt_injection.dart';
import 'package:butterfly/core/di/network_injection.dart';
import 'package:butterfly/core/di/prefs_injection.dart';
import 'package:butterfly/core/di/repo_injection.dart';
import 'package:butterfly/core/di/usecases_injection.dart';

// This file is used to configure all dependencies injection in the application.
Future<void> configureDependencies() async {
  await registerPreferences();
  registerNetwork();
  registerDatabaseManagers();
  registerRepositories();
  registerBlocs();
  registerMqtt();
  registerUseCases();
}


// flutter pub run build_runner clean
// flutter pub run build_runner build --delete-conflicting-outputs
