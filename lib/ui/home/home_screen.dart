import 'package:butterfly/navigation/routes.dart';
import 'package:butterfly/ui/home/bloc/home_bloc.dart';
import 'package:butterfly/ui/home/bottombar/BottomNavBar.dart';
import 'package:butterfly/ui/home/bottombar/BottomNavCubit.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedIndex(context);
    });
  }

  void _updateSelectedIndex(BuildContext context) {
    context
        .read<BottomNavCubit>()
        .setIndex(widget.navigationShell.currentIndex);
  }

  void _goBranch(int index) {
    context.read<BottomNavCubit>().setIndex(index);
    AppLogger.showError(
      'HomeScreen: _goBranch: index = $index',
    );
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          GoRouter.of(context).goNamed(Routes.loginRouteName);
        }
      },
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: BlocBuilder<BottomNavCubit, int>(
          builder: (context, selectedIndex) {
            return BottomNavBar(
              selectedIndex: selectedIndex,
              onItemTapped: _goBranch,
            );
          },
        ),
      ),
    );
  }
}
