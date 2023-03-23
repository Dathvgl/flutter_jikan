import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/firebase/store/user.dart';
import 'package:flutter_jikan/models/jsons/user.dart';
import 'package:flutter_jikan/models/providers/my_list.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

AuthFirebase get auth => Get.find<AuthFirebase>();

class AuthFirebase {
  final _firebaseAuth = FirebaseAuth.instance;

  Map<String, dynamic> info = UserModel(name: "Unknown").toJson();

  bool get isAuthen => _firebaseAuth.currentUser != null;

  String get uid => _firebaseAuth.currentUser!.uid;

  Stream<User?> get state => _firebaseAuth.authStateChanges();

  Future<String?> signUp({
    required String? email,
    required String? password,
  }) async {
    if (email is String && password is String) {
      try {
        await _firebaseAuth
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) {
          final item = UserModel(
            id: value.user?.uid,
            name: "Unknow",
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
      await _firebaseAuth.signInWithEmailAndPassword(
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

  Future<void> signOut({
    required BuildContext context,
  }) async {
    context.read<MyListProvider>().clear();
    await _firebaseAuth.signOut();
  }
}
