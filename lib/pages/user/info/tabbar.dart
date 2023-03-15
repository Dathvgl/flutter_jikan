import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/tabbar.dart';
import 'package:flutter_jikan/pages/user/info/listview.dart';

class UserInfoTabBar extends StatefulWidget {
  const UserInfoTabBar({super.key});

  @override
  State<UserInfoTabBar> createState() => _UserInfoTabBarState();
}

class _UserInfoTabBarState extends State<UserInfoTabBar>
    with TickerProviderStateMixin {
  final tabs = const [
    Text("Anime"),
    Text("Character"),
    Text("Person"),
  ];

  final children = const [
    UserInfoListView(),
    Text("Character"),
    Text("Person"),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = TabController(
      length: tabs.length,
      vsync: this,
    );

    return TabBarDart(
      controller: controller,
      tabs: tabs,
      children: children,
    );
  }
}
