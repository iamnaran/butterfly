import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {

    AppLogger.showError(
      'BottomNavBar: selectedIndex = $selectedIndex'
    );
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
      onTap: onItemTapped, 
    );
  }
}