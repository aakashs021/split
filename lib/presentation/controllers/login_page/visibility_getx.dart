import 'package:get/get.dart';

class VisibilityGetx extends GetxController {
  bool obscureText=false;

  OnTap(){
    obscureText=!obscureText;
    update();
  }
}