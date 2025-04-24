import 'package:butterfly/navigation/routes.dart';
import 'package:butterfly/ui/home/bloc/home_bloc.dart';
import 'package:butterfly/ui/home/bottombar/BottomNavCubit.dart';
import 'package:butterfly/ui/widgets/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.child});

  final Widget child;

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

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedIndex(context);
    });
  }

  void _updateSelectedIndex(BuildContext context) {
    final currentRoute =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    final bottomNavCubit = context.read<BottomNavCubit>();
    if (currentRoute == '/profile') {
      bottomNavCubit.setIndex(1);
    } else if (currentRoute == '/search') {
      bottomNavCubit.setIndex(2);
    } else {
      bottomNavCubit.setIndex(0);
    }
  }

  void _onItemTapped(int index) {
    context.read<BottomNavCubit>().setIndex(index);
    switch (index) {
      case 0:
        context.goNamed(Routes.exploreRouteName);
        break;
      case 1:
        context.goNamed(Routes.profileRouteName);
        break;
      case 2:
        context.goNamed(Routes.searchRouteName);
        break;
    }
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
        appBar: _buildAppBar(context),
        body: widget.child,
        bottomNavigationBar: BlocBuilder<BottomNavCubit, int>(
          builder: (context, selectedIndex) {
            return BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
              ],
              currentIndex: selectedIndex,
              selectedItemColor: Colors.blue,
              selectedFontSize: 12.0,
              unselectedFontSize: 12.0,
              onTap: _onItemTapped, // Using the _onItemTapped function directly
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final currentRoute =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    final ThemeData theme = Theme.of(context);

    String title = '';
    List<Widget> actions = [];

    if (currentRoute == Routes.explorePath) {
      title = 'Explore';
      actions.add(
        AppPopupMenu<String>(
          items: [
            const PopupMenuItem<String>(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
          onSelected: (value) {
            if (value == 'logout') {
              context.read<HomeBloc>().add(LogoutUser());
            }
          },
          icon: const Icon(Icons.account_circle),
        ),
      );
    } else if (currentRoute == Routes.profilePath) {
      title = 'Profile';
    } else if (currentRoute == Routes.searchPath) {
      title = 'Search';
    }

    return AppBar(
      title: Text(title),
      backgroundColor: theme.colorScheme.secondary,
      foregroundColor: theme.colorScheme.onSecondary,
      actions: actions,
    );
  }
}
