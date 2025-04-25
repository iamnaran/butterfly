import 'package:flutter/material.dart';

class AppMediumText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight; 
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextStyle? style;
  final VoidCallback? onTap;

  const AppMediumText({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTextStyle = theme.textTheme.bodyMedium;
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        style: style?.copyWith(
              color: color ?? defaultTextStyle?.color,
              fontWeight: fontWeight ?? defaultTextStyle?.fontWeight,
            ) ??
            defaultTextStyle?.copyWith(
              color: color,
              fontWeight: fontWeight,
            ),
      ),
    );
  }
}