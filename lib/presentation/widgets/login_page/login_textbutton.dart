import 'package:flutter/material.dart';
import 'package:split/presentation/pages/login_page/login_page.dart';

TextButton textbuttons(
        {required BuildContext context,
        required String text,
        required Widget navpage}) =>
    TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize:
            MaterialTapTargetSize.shrinkWrap, 
      ),
      onPressed: () {
        if (navpage.runtimeType == LoginPage) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => navpage,
            ),
            (route) => false,
          );
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => navpage,
          ));
        }
      },
      child: Text(
        text,
        style: const TextStyle(color: Colors.blue, fontSize: 16),
      ),
    );
