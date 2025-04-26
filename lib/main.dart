import 'dart:async';

import 'package:butterfly/core/database/hive_initalizer.dart';
import 'package:butterfly/core/di/di_module.dart';
import 'package:butterfly/core/preference/pref_manager.dart';
import 'package:butterfly/navigation/router.dart';
import 'package:butterfly/theme/theme.dart';
import 'package:butterfly/theme/typography.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initHive();
    await configureDependenciesInjection();
    AppLogger.configureLogging();

    runApp(MyApp());
  }, (error, stackTrace) {
    AppLogger.showError('Caught an error: $error');
    AppLogger.showError('Stack trace: $stackTrace');
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateThemeForPlatformBrightness();
  }

  @override
  void didChangePlatformBrightness() {
    _updateThemeForPlatformBrightness();
  }

  void _updateThemeForPlatformBrightness() {
    final platformBrightness =
        View.of(context).platformDispatcher.platformBrightness;
    setState(() {
      _themeMode = platformBrightness == Brightness.light
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MaterialTheme theme = MaterialTheme(appTextStyle);

    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    final statusBarIconBrightness =
        isDarkMode ? Brightness.light : Brightness.dark;
    Color? statusBarColor;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarBrightness: statusBarIconBrightness,
      statusBarIconBrightness: statusBarIconBrightness,
    ));

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Butterfly',
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: _themeMode,
      routerConfig:
          AppRouter.getRouter(getIt<PreferenceManager>().getLoggedIn()),
    );
  }
}

// dart run build_runner build --delete-conflicting-outputs
