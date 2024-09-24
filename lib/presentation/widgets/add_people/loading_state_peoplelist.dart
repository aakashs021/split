import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget loadingStatePeopleList() {
  return Column(
    children: [
      const SizedBox(
        height: 50,
      ),
      LoadingAnimationWidget.hexagonDots(
          color: Colors.grey.shade700, size: 100),
      const SizedBox(
        height: 50,
      )
    ],
  );
}
