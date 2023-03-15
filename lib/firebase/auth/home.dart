import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/models/providers/my_list.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

AuthFirebase get auth => Get.find<AuthFirebase>();

class AuthFirebase {
  final _firebaseAuth = FirebaseAuth.instance;

  bool get isAuthen => _firebaseAuth.currentUser != null;

  String get uid => _firebaseAuth.currentUser!.uid;

  Map<String, dynamic> get info => {
    "name": _firebaseAuth.currentUser?.displayName,
    "image": _firebaseAuth.currentUser?.photoURL,
  };

  Stream<User?> get state => _firebaseAuth.authStateChanges();

  // String get userName => isAuthen ? _firebaseAuth.currentUser!.email ?? "" : "";

  // void sendEmailLink({
  //   required String email,
  // }) async {
  //   SPService.instance.setString('passwordLessEmail', email);
  //   await _firebaseAuth
  //       .sendSignInLinkToEmail(
  //         email: email,
  //         actionCodeSettings: ActionCodeSettings(
  //           url: "https://flutterjikanapi.page.link/29hQ?email=$email",
  //           handleCodeInApp: true,
  //           androidPackageName: "com.example.flutter_jikan_api",
  //         ),
  //       )
  //       .catchError((onError) => print("Error: $onError"));
  // }

  // void retrieveEmailLink({
  //   required bool state,
  // }) async {
  //   final email = SPService.instance.getString('passwordLessEmail') ?? '';
  //   PendingDynamicLinkData? dynamicLinkData;

  //   Uri? deepLink;
  //   if (state) {
  //     dynamicLinkData = await FirebaseDynamicLinks.instance.getInitialLink();
  //     if (dynamicLinkData != null) {
  //       deepLink = dynamicLinkData.link;
  //     }
  //   } else {
  //     dynamicLinkData = await FirebaseDynamicLinks.instance.onLink.first;
  //     deepLink = dynamicLinkData.link;
  //   }

  //   if (deepLink != null) {
  //     bool validLink = _firebaseAuth.isSignInWithEmailLink(deepLink.toString());

  //     SPService.instance.setString('passwordLessEmail', '');
  //     if (validLink) {
  //       final userCredential = await _firebaseAuth.signInWithEmailLink(
  //         email: email,
  //         emailLink: deepLink.toString(),
  //       );

  //       if (userCredential.user != null) {
  //         print("None user");
  //       }
  //     }
  //   }
  // }

  Future<String?> signUp({
    required String? email,
    required String? password,
  }) async {
    if (email is String && password is String) {
      try {
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
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
