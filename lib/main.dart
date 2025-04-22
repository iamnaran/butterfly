import 'package:butterfly/ui/auth/login_screen.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/material.dart';

void main() {
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
