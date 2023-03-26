import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/navigation/go_router.dart';
import 'package:flutter_jikan/components/scaffod.dart';
import 'package:flutter_jikan/models/providers/my_list.dart';
import 'package:flutter_jikan/models/providers/theme.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavigationPage> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  MyListProvider myListProvider = MyListProvider();

  final light = ThemeData.light();
  final dark = ThemeData.dark();

  final router = GoRouterDart.router;

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    myListProvider.init();
  }

  @override
  void dispose() {
    myListProvider.dispose();
    myListProvider.listen?.cancel();
    myListProvider.dispose();
    super.dispose();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkThemeProvider>.value(
          value: themeChangeProvider,
        ),
        ChangeNotifierProvider<MyListProvider>.value(
          value: myListProvider,
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp.router(
            builder: (context, child) {
              return SafeArea(
                child: child ?? const SizedBox(),
              );
            },
            theme: themeChangeProvider.darkTheme ? light : dark,
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
          );
        },
      ),
    );
  }
}

class BottomItem extends BottomNavigationBarItem {
  final String path;

  const BottomItem({
    required this.path,
    required super.icon,
    super.label,
    super.backgroundColor,
  });
}

class NavigationBottom extends StatefulWidget {
  final Widget child;

  const NavigationBottom({
    super.key,
    required this.child,
  });

  @override
  State<NavigationBottom> createState() => _NavBottomState();
}

class _NavBottomState extends State<NavigationBottom> {
  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  int _locationToTabIndex(String location) {
    final index = tabs.indexWhere((item) => location.startsWith(item.path));
    return index < 0 ? 0 : index;
  }

  void _onItemTapped(BuildContext context, int tabIndex) {
    if (tabIndex != _currentIndex) {
      context.go(tabs[tabIndex].path);
    }
  }

  final tabs = [
    const BottomItem(
      path: '/home',
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomItem(
      path: '/discussion',
      icon: Icon(Icons.bloodtype_outlined),
      label: 'Discussion',
    ),
    const BottomItem(
      path: '/discover',
      icon: Icon(Icons.search),
      label: 'Discover',
    ),
    const BottomItem(
      path: '/seasonal',
      icon: Icon(Icons.screen_share_outlined),
      label: 'Seasonal',
    ),
    const BottomItem(
      path: '/mylist',
      icon: Icon(Icons.menu_book),
      label: 'My List',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: tabs,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
