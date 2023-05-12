import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../keys.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  AuthType _authType = AuthType.signIn;
  AuthType get authType => _authType;

  // create instances of
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  /// setAuthType method
  setAuthType() {
    _authType = _authType == AuthType.signIn ? AuthType.signUp : AuthType.signIn;
    notifyListeners();
  } //setAuthType

  /// authenticate method
  authenticate() async {
    UserCredential userCredential;
    try {
      if (_authType == AuthType.signUp) {
        userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);

        /// verify email section 3, step 13 2:05
        await userCredential.user!.sendEmailVerification();

        await firebaseFirestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'uid': userCredential.user!.uid,
          'user_name': userNameController.text,
        });
      } //if

      if (_authType == AuthType.signIn) {
        userCredential = await firebaseAuth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      } // if
    } on FirebaseAuthException catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.code),
        backgroundColor: Colors.red,
      ));
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    } //catch
  } //authenticate

  /// updateEmailVerificationState method

  bool? emailVerified;
  updateEmailVerificationState() async {
    emailVerified = firebaseAuth.currentUser!.emailVerified;

    ///  add timer  section 3, step 13 at about 7:00
    if (!emailVerified!) {
      Timer.periodic(const Duration(seconds: 3), (timer) async {
        await firebaseAuth.currentUser!.reload();
        final user = FirebaseAuth.instance.currentUser;

        /// add if statement section 3, step 13 at about 8:10
        if (user!.emailVerified) {
          emailVerified = user!.emailVerified;
          timer.cancel();
          notifyListeners();
        }
      });
    } // if
  } // updateEmailVerificationState

  /// logOut method
  logOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    } //catch
  } //logOut
} //class

enum AuthType {
  signUp,
  signIn,
}
