import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color? shadowColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  const ShadowContainer({
    super.key,
    required this.child,
    this.elevation = 4,
    this.shadowColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeShadowColor = Theme.of(context).cardTheme.shadowColor ?? Colors.black;
    final effectiveShadowColor = shadowColor ?? themeShadowColor;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: borderRadius ?? BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: effectiveShadowColor.withOpacity(0.2),
            blurRadius: elevation * 2,
            spreadRadius: elevation * 0.5,
            offset: Offset(0, elevation),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: child,
      ),
    );
  }
}
