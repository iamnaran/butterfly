import 'dart:ui';

import 'package:butterfly/ui/home/widgets/home_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MorphingPersistentSheet extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MorphingPersistentSheet({super.key, required this.navigationShell});

  @override
  State<MorphingPersistentSheet> createState() =>
      _MorphingPersistentSheetState();
}

class _MorphingPersistentSheetState extends State<MorphingPersistentSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Sheet State
  double _sheetHeight = 0.15; // Start collapsed
  double _minHeight = 0.15; // Will be calculated
  final double _midHeight = 0.5; // Half expanded state
  double _maxHeight = 1.0;

  // Drag State
  double _dragStartY = 0;
  double _sheetHeightOnDragStart = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // --- Logic for Morphing ---

  void _handleDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
    _sheetHeightOnDragStart = _sheetHeight;
    _animationController.stop();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final dragDistance = details.globalPosition.dy - _dragStartY;
    final dragAmountNormalized = dragDistance / screenHeight;

    // Pulling down (positive drag) decreases height
    double newHeight = _sheetHeightOnDragStart - dragAmountNormalized;

    // Clamp
    if (newHeight < _minHeight) newHeight = _minHeight;
    if (newHeight > _maxHeight) newHeight = _maxHeight;

    setState(() {
      _sheetHeight = newHeight;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final velocityClipped = details.primaryVelocity! / screenHeight;

    double targetHeight = _minHeight;

    // Snap logic with 3 states: Min, Mid, Max
    final List<double> snapPoints = [_minHeight, _midHeight, _maxHeight];

    // Calculate projected position based on velocity to give "throw" feel
    double projectedHeight = _sheetHeight - (velocityClipped * 0.2);

    // Find nearest snap point
    targetHeight = snapPoints.reduce((a, b) {
      double distA = (a - projectedHeight).abs();
      double distB = (b - projectedHeight).abs();
      return distA < distB ? a : b;
    });

    // Directional override for strong swipes near current state
    if (velocityClipped < -0.5) {
      // Swipe Up strongly: Go to next state up
      if (_sheetHeight < _midHeight - 0.05) {
        targetHeight = _midHeight;
      } else {
        targetHeight = _maxHeight;
      }
    } else if (velocityClipped > 0.5) {
      // Swipe Down strongly: Go to next state down
      if (_sheetHeight > _midHeight + 0.05) {
        targetHeight = _midHeight;
      } else {
        targetHeight = _minHeight;
      }
    }

    _animateToHeight(targetHeight);
  }

  void _animateToHeight(double target) {
    final start = _sheetHeight;
    _animationController.reset();
    _animationController.duration = const Duration(milliseconds: 300);

    final Animation<double> curve = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutCubic);

    curve.addListener(() {
      setState(() {
        _sheetHeight = start + (target - start) * curve.value;
      });
    });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final safeAreaTop = MediaQuery.of(context).padding.top;

    // Calculate Max Height (below status bar)
    if (screenHeight > 0) {
      _maxHeight = (screenHeight - safeAreaTop) / screenHeight;
    }

    // Dynamic Min Height Calculation:
    // Handle (25) + BottomNav (Icon 28 + Gap 4 + Text 12 + TopPad 10 + BottomPad (variable))
    double bottomPadding = safeAreaBottom > 0 ? safeAreaBottom : 10;
    // 25 + 54 + bottomPadding -> Reduced to 70 for balanced layout with top padding
    double minPixelHeight = 70 + bottomPadding;

    if (screenHeight > 0) {
      // Add a tiny buffer (2px)
      _minHeight = ((minPixelHeight + 2) / screenHeight).clamp(0.05, 0.4);
    }

    // Ensure initial state aligns with min height if not already modified
    // (In a real app, might want to do this only once)

    // Calculate t (expansion progress 0.0 -> 1.0)
    final t = ((_sheetHeight - _minHeight) / (_maxHeight - _minHeight))
        .clamp(0.0, 1.0);

    // Morphing parameters
    // Padding: 26 -> 0
    final double paddingVal = lerpDouble(26, 0, t)!;
    // Radius: 50 -> 0 (Matches phone corner radius approx)
    final double radiusVal = lerpDouble(50, 0, Curves.easeIn.transform(t))!;

    // Actual height in pixels
    final double currentPixelHeight = _sheetHeight * screenHeight;

    return Positioned(
      left: paddingVal,
      right: paddingVal,
      bottom: paddingVal, // Also float from bottom initially
      height: currentPixelHeight,
      child: GestureDetector(
        onVerticalDragStart: _handleDragStart,
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(radiusVal),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radiusVal),
            child: Column(
              children: [
                // Header / Drag Handle
                Container(
                  width: double.infinity,
                  color: Colors.transparent, // Hit test target
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                ),

                // Inner Content (Navigation Shell)
                Expanded(
                  child: widget.navigationShell,
                ),

                // Bottom Navigation Bar
                HomeBottomBar(navigationShell: widget.navigationShell),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
