import 'package:butterfly/data/local/preference/pref_manager.dart';
import 'package:butterfly/main.dart';
import 'package:butterfly/ui/home/home_screen.dart';
import 'package:butterfly/ui/home/modern_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeSwitcher extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeSwitcher({super.key, required this.navigationShell});

  @override
  State<HomeSwitcher> createState() => _HomeSwitcherState();
}

class _HomeSwitcherState extends State<HomeSwitcher> {
  late bool _isModernHome;

  @override
  void initState() {
    super.initState();
    _isModernHome = getIt<PreferenceManager>().getModernHome();
  }

  Future<void> _toggleHomeView() async {
    final newValue = !_isModernHome;
    setState(() {
      _isModernHome = newValue;
    });
    await getIt<PreferenceManager>().setModernHome(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The current home screen
          _isModernHome
              ? ModernHomeScreen(navigationShell: widget.navigationShell)
              : HomeScreen(navigationShell: widget.navigationShell),

          // The toggle button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: GestureDetector(
              onTap: _toggleHomeView,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isModernHome ? Icons.grid_view : Icons.home,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isModernHome ? 'Classic View' : 'Modern View',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
