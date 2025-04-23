import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTransitions {

static Widget fadeTransition(BuildContext context, Widget child) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200), 
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeInOutCubic,
      builder: (BuildContext context, double opacity, Widget? child) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: child,
    );
  }

  static CustomTransitionPage<void> fade(
    {required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage<void> slide(
    {required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Offset? beginOffset,
  }) {
    final offset = beginOffset ?? const Offset(1.0, 0.0);
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: offset,
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }
}
