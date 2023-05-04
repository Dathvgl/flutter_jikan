import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_jikan/extension/home.dart';
import 'package:flutter_jikan/firebase/store/user.dart';
import 'package:flutter_jikan/models/jsons/user.dart';
import 'package:flutter_jikan/models/providers/my_list.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:faker/faker.dart';
import 'package:provider/provider.dart';

AuthFirebase auth = AuthFirebase();

final _faker = Faker();

class AuthFirebase {
  final instance = FirebaseAuth.instance;

  Map<String, dynamic> info = UserModel(name: "Unknown").toJson();

  bool get isAuthen => instance.currentUser != null;

  String get uid => instance.currentUser!.uid;

  Stream<User?> get state => instance.authStateChanges();

  Future<String?> signUp({
    required String? email,
    required String? password,
  }) async {
    if (email is String && password is String) {
      try {
        await instance
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) {
          final item = UserModel(
            id: value.user?.uid,
            name: _faker.internet.userName(),
            dateCreate: DateTime.now().toIso8601String(),
          );

          UserStore.addUser(item);
        });
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "weak-password":
            return "The password provided is too weak";
          case "email-already-in-use":
            return "The account already exists for that email";
        }
      } catch (e) {
        return "Error sign up";
      }
    }

    return null;
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "No user found for that email";
        case "wrong-password":
          return "Wrong password provided for that user";
      }
    } catch (e) {
      return "Error sign in";
    }

    return null;
  }

  Future<String?> google() async {
    try {
      final user = await GoogleSignIn().signIn();
      final userAuth = await user?.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: userAuth?.idToken,
        accessToken: userAuth?.accessToken,
      );

      final result = await auth.instance.signInWithCredential(credential);
      if (result.additionalUserInfo?.isNewUser ?? false) {
        final item = UserModel(
          id: result.user?.uid,
          name: result.additionalUserInfo?.profile?["name"],
          imageUrl: result.additionalUserInfo?.profile?["picture"],
          dateCreate: DateTime.now().toIso8601String(),
        );

        UserStore.addUser(item);
      }
    } on FirebaseAuthException catch (e) {
      final code = e.code;
      switch (code) {
        case "account-exists-with-different-credential":
          return code.replaceAll("-", " ").toCapitalized();
        case "invalid-credential":
          return code.replaceAll("-", " ").toCapitalized();
      }
    } catch (e) {
      return "Error sign in";
    }

    return null;
  }

  Future<String?> facebook() async {
    final user = await FacebookAuth.instance.login();

    if (user.status == LoginStatus.success) {
      final credential = FacebookAuthProvider.credential(
        user.accessToken!.token,
      );
      try {
        final result = await auth.instance.signInWithCredential(credential);
        if (result.additionalUserInfo?.isNewUser ?? false) {
        final item = UserModel(
          id: result.user?.uid,
          name: result.additionalUserInfo?.profile?["name"],
          imageUrl: result.additionalUserInfo?.profile?["picture"],
          dateCreate: DateTime.now().toIso8601String(),
        );

        UserStore.addUser(item);
      }
      } on FirebaseAuthException catch (e) {
        final code = e.code;
        switch (code) {
          case "account-exists-with-different-credential":
            return code.replaceAll("-", " ").toCapitalized();
          case "invalid-credential":
            return code.replaceAll("-", " ").toCapitalized();
        }
      } catch (e) {
        return "Error sign in";
      }
    }

    return null;
  }

  Future<void> signOut({
    required BuildContext context,
  }) async {
    context.read<MyListProvider>().clear();
    await instance.signOut();
  }
}
