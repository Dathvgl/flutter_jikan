import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/drawer.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget? body;
  final Widget? drawer;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final BottomNavigationBar? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const CustomScaffold({
    super.key,
    this.title = "fsfssfssfsfsfs",
    this.body,
    this.drawer = const DrawerMain(),
    this.actions,
    this.bottom,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: actions,
        bottom: bottom,
      ),
      body: body,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
