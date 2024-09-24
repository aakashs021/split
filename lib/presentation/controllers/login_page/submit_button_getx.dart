import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:split/fonts.dart';

class SubmitButtonGetx extends GetxController {
  bool button = false;
  onTap() {
    button = true;
    update();
  }

  Widget loadingtextWidget({required String text}) {
    if (button) {
      return LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.white, size: 35);
    } else {
      return loginpageSubmitbutton(data: text);
    }
  }
}
