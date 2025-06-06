import 'dart:async';

import 'package:butterfly/core/database/hive_initalizer.dart';
import 'package:butterfly/core/di/app_configuration.dart';
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
    await configureDependencies();
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
    final brightness = MediaQuery.platformBrightnessOf(context);
    _updateStatusBarStyle(brightness);
    setState(() {
      _themeMode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _updateStatusBarStyle(Brightness brightness) {
    final isDarkMode = brightness == Brightness.dark;
    final iconBrightness = isDarkMode ? Brightness.light : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: iconBrightness,
      statusBarIconBrightness: iconBrightness,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MaterialTheme(appTextStyle);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Butterfly',
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: _themeMode,
      routerConfig: AppRouter.getRouter(getIt<PreferenceManager>().getLoggedIn()),
    );
  }
}


// dart run build_runner build --delete-conflicting-outputs
