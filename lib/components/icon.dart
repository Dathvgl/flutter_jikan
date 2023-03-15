import 'package:flutter/material.dart';

class IconContainerDart extends StatelessWidget {
  final IconData iconData;
  final void Function()? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;

  const IconContainerDart({
    super.key,
    required this.iconData,
    this.onPressed,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(5),
        color: backgroundColor,
        child: Icon(
          iconData,
          color: iconColor,
        ),
      ),
    );
  }
}
