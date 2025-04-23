import 'package:flutter/material.dart';

class AppPopupMenu<T> extends StatelessWidget {
  const AppPopupMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.icon,
  });

  final List<PopupMenuEntry<T>> items;
  final PopupMenuItemSelected<T>? onSelected;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => items,
      child: icon ?? const Icon(Icons.more_vert), 
    );
  }
}