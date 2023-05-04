import 'package:flutter/material.dart';
import 'package:flutter_jikan/components/circle_avatar.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/main.dart';
import 'package:flutter_jikan/models/providers/theme.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

class DrawerMain extends StatelessWidget {
  const DrawerMain({super.key});

  @override
  Widget build(BuildContext context) {
    close() => Navigator.pop(context);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            drawerHeader(
              context: context,
              close: close,
            ),
            drawerBody(
              context: context,
              close: close,
            ),
          ],
        ),
      ),
    );
  }
}

Widget drawerHeader({
  required BuildContext context,
  required void Function() close,
}) {
  Widget iconAvatar() {
    return const CircleAvatar(
      backgroundColor: Colors.white,
      child: Icon(
        Icons.person,
        color: Colors.black,
      ),
    );
  }

  return Container(
    padding: const EdgeInsets.all(20),
    color: Theme.of(context).primaryColor,
    child: InkWell(
      onTap: () {
        close();

        if (auth.isAuthen) {
          // context.push("/user/info");
        } else {
          context.push("/user/screen");
        }
      },
      child: Row(
        children: [
          authBuild(
            done: auth.info["imageUrl"] != null
                ? CircleAvatarDart(
                    backgroundImage: auth.info["imageUrl"],
                  )
                : iconAvatar(),
            none: iconAvatar(),
          ),
          const SizedBox(
            width: 20,
          ),
          authBuild(
            done: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auth.info["name"] ?? "Unknow",
                  style: const TextStyle(
                    color: Colors.lime,
                    fontSize: 16,
                  ),
                ),
                const Text("Profile"),
              ],
            ),
            none: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Log in",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("or create an account"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget drawerBody({
  required BuildContext context,
  required void Function() close,
}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);

  return Column(
    children: [
      ListTile(
        title: const Text("Theme"),
        trailing: Switch(
          value: themeChange.darkTheme,
          onChanged: (value) {
            themeChange.darkTheme = value;
          },
        ),
      ),
      authBuild(
        none: const SizedBox(),
        done: ListTile(
          onTap: () => auth.signOut(
            context: context,
          ),
          title: const Text("Sign out"),
        ),
      ),
    ],
  );
}
