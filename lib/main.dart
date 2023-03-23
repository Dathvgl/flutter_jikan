import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/navigation/home.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/database/home.dart';
import 'package:flutter_jikan/firebase/firebase_options.dart';
import 'package:flutter_jikan/firebase/store/home.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// flutter run --enable-software-rendering
// flutter pub run build_runner build
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

Future<void> init() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.lazyPut(() => AuthFirebase());
  Get.lazyPut(() => StoreFirebase());
  Get.lazyPut(() => RealtimeFirebase());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigationPage();
  }
}

Widget httpBuild({
  required AsyncSnapshot<dynamic> snapshot,
  required Widget widget,
}) {
  switch (snapshot.connectionState) {
    case ConnectionState.none:
    case ConnectionState.waiting:
      return const Center(
        child: CircularProgressIndicator(),
      );
    case ConnectionState.done:
    case ConnectionState.active:
    default:
      if (snapshot.hasData) {
        return widget;
      } else if (snapshot.hasError) {
        return const Text("Error!");
      } else {
        return const Text("No data!");
      }
  }
}

Widget authBuild({
  required Widget done,
  required Widget none,
}) {
  return StreamBuilder(
    stream: auth.state,
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
          return const Center(
            child: CircularProgressIndicator(),
          );
        case ConnectionState.done:
        case ConnectionState.active:
        default:
          if (snapshot.hasData) {
            return done;
          } else {
            return none;
          }
      }
    },
  );
}

Widget scrollableWin({
  required BuildContext context,
  required Widget child,
}) {
  return ScrollConfiguration(
    behavior: ScrollConfiguration.of(context).copyWith(
      dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      },
    ),
    child: child,
  );
}

String kDot(int num) {
  return NumberFormat.compact().format(num);
}
