import 'package:ada_student_app/constants.dart';
import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    required this.click,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final void Function() click;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(width ?? 272, height ?? 48)),
        backgroundColor: WidgetStatePropertyAll(backgroundColor ?? kgreen),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: BorderSide(color: borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.circular(borderRadius ?? 4),
          ),
        ),
        padding: WidgetStatePropertyAll(
          padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
      onPressed: click,
      child: child,
    );
  }
}
