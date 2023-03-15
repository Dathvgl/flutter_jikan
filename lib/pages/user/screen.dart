import 'package:flutter/material.dart';
import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/models/providers/my_list.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';

class LoginDart extends StatelessWidget {
  const LoginDart({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return auth.signIn(
        email: data.name,
        password: data.password,
      );
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loginTime).then((value) {
      return auth.signUp(
        email: data.name,
        password: data.password,
      );
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return "Haha";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Jikan',
      onLogin: _authUser,
      onSignup: _signupUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () {
        context.read<MyListProvider>().init();
        context.go("/home");
      },
    );
  }
}
