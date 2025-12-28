import 'package:butterfly/navigation/routes.dart';
import 'package:butterfly/ui/home/bloc/home_bloc.dart';
import 'package:butterfly/ui/home/widgets/custom_map_background.dart';
import 'package:butterfly/ui/home/widgets/morphing_persistent_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ModernHomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ModernHomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          GoRouter.of(context).goNamed(Routes.loginRouteName);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // 1. Map Background (Static)
            // 1. Map Background (Static)
            const Positioned.fill(
              child: CustomMapBackground(),
            ),

            // 2. Custom Persistent View
            MorphingPersistentSheet(navigationShell: navigationShell),
          ],
        ),
      ),
    );
  }
}
