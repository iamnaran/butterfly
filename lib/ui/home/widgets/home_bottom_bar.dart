import 'package:butterfly/ui/home/bottombar/BottomNavCubit.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeBottomBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeBottomBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    // Define tabs here or pass them in if they need to be dynamic
    final List<String> tabNames = ['Explore', 'Profile', 'News'];
    final List<IconData> tabIcons = [
      CupertinoIcons.compass_fill,
      CupertinoIcons.person_fill,
      CupertinoIcons.news_solid,
    ];

    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, selectedIndex) {
        // Calculate safe area bottom padding
        final safeAreaBottom = MediaQuery.of(context).padding.bottom;
        final bottomPadding = safeAreaBottom > 0 ? safeAreaBottom : 10.0;

        return Container(
          padding: EdgeInsets.only(
            top: 10,
            bottom: bottomPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(tabNames.length, (index) {
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () => _goBranch(context, index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tabIcons[index],
                      color: isSelected ? Colors.blue : Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tabNames[index],
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  void _goBranch(BuildContext context, int index) {
    context.read<BottomNavCubit>().setIndex(index);
    AppLogger.showError(
      'HomeBottomBar: _goBranch: index = $index',
    );
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
