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
    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.blue,
              );
            }
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            );
          }),
        ),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper_rounded),
            label: 'News Feeds',
          ),
        ],
      ),
    );
  }


}