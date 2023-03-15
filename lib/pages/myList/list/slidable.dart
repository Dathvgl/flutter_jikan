import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableItem {
  final String label;
  final IconData icon;
  final Map<String, dynamic> map;
  final Color backgroundColor;
  final void Function(Map<String, dynamic> map) onPressed;

  SlidableItem({
    required this.label,
    required this.icon,
    required this.map,
    required this.backgroundColor,
    required this.onPressed,
  });
}

class MyListListSlidable extends StatelessWidget {
  final Widget child;
  final Widget motion;
  final List<SlidableItem> list;

  const MyListListSlidable({
    super.key,
    required this.child,
    this.motion = const DrawerMotion(),
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: motion,
        children: list.map((item) {
          return SlidableAction(
            label: item.label,
            icon: item.icon,
            backgroundColor: item.backgroundColor,
            onPressed: (context) {
              item.onPressed(item.map);
            },
          );
        }).toList(),
      ),
      child: child,
    );
  }
}
