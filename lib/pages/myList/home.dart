import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/tabbar.dart';
import 'package:flutter_jikan/enums/item.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/jsons/my_list.dart';
import 'package:flutter_jikan/models/providers/my_list.dart';
import 'package:flutter_jikan/pages/myList/list/home.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({super.key});

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final tabs = [
    const Text("All"),
    Text(ItemStateType.watching.name),
    Text(ItemStateType.completed.name),
    Text(ItemStateType.planToWatch.name),
    Text(ItemStateType.onHold.name),
    Text(ItemStateType.dropped.name),
  ];

  List<Widget> children(List<MyListModel> list) {
    List<Widget> array = ItemStateType.values.map((item) {
      return MyListList(
        state: item.name,
        myList: list.where((element) {
          return element.state == item.name;
        }).toList(),
      );
    }).toList();

    array.insert(0, MyListList(state: "All", myList: list));
    return array;
  }

  @override
  Widget build(BuildContext context) {
    return authBuild(
      none: AlertDialog(
        title: const Text("Need sign in!"),
        content: TextButton(
          child: const Text("Sign in"),
          onPressed: () {
            context.push("/user/screen");
          },
        ),
      ),
      done: Consumer<MyListProvider>(
        builder: (context, value, child) {
          final list = value.userMyList;

          return TabBarDart(
            controller: controller,
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10,
            ),
            tabs: tabs,
            children: children(list),
          );
        },
      ),
    );
  }
}
