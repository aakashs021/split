import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:split/presentation/pages/home_page/home_screen.dart';
import 'package:split/presentation/widgets/login_page/loginpage_snackbar.dart';

userLogin(
    {required BuildContext context,
    required String email,
    required String password}) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      (route) => false,
    );
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'No user found for that email.';
        break;
      case 'wrong-password':
        errorMessage = 'Wrong password provided for that user.';
        break;
      case 'invalid-credential':
        errorMessage = 'The email address or password in incorrect';
        break;
      default:
        errorMessage = 'An unexpected error occurred.';
    }
    loginpageSnackbar(context: context, e: errorMessage);
  }
}
