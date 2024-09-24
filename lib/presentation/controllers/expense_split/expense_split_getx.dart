import 'package:get/get.dart';

class ExpenseSplitGetx extends GetxController {
  int index=2;
  ontap({required int index}){
    this.index=index;
    update();
  }
}