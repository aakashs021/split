import 'package:flutter/material.dart';

loginpageSnackbar({required BuildContext context, required String? e}) {
  
  ScaffoldMessenger.of(context)
      .clearSnackBars(); // Clear all existing SnackBars

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 15),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.red,
      elevation: 20,
      content: Text(e!)));
}