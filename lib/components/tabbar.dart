import 'package:flutter/material.dart';

class TabBarDart extends StatelessWidget {
  final void Function(int value)? onTap;
  final TabController controller;
  final EdgeInsetsGeometry? labelPadding;
  final bool isScrollable;
  final List<Widget> tabs;
  final List<Widget> children;
  final Color? indicatorColor;
  final Color? backgroundColor;

  const TabBarDart({
    super.key,
    this.onTap,
    required this.controller,
    this.labelPadding = const EdgeInsets.all(10),
    this.isScrollable = false,
    required this.tabs,
    required this.children,
    this.indicatorColor = Colors.green,
    this.backgroundColor = Colors.blue,
  });

  Widget container({
    required Widget child,
  }) {
    if (isScrollable) {
      return Container(
        width: double.infinity,
        color: backgroundColor,
        child: child,
      );
    } else {
      return Container(
        color: backgroundColor,
        child: child,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: container(
            child: TabBar(
              onTap: onTap,
              controller: controller,
              tabs: tabs,
              labelPadding: labelPadding,
              isScrollable: isScrollable,
              indicator: BoxDecoration(
                color: indicatorColor,
              ),
            ),
          ),
        ),
        Flexible(
          child: TabBarView(
            controller: controller,
            children: children,
          ),
        ),
      ],
    );
  }
}
