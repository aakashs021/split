import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:split/presentation/controllers/login_page/submit_button_getx.dart';
import 'package:split/presentation/controllers/login_page/user_login_controller.dart';

Widget loginButton(
    {required BuildContext context,
    required var formkey,
    required List<TextEditingController> controller,
    String page = "home"}) {
  String buttonname = page == 'home' ? 'Login' : 'Sign Up';
  Get.put(SubmitButtonGetx());
  return SizedBox(
    height: 50,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          String email =
              page == 'home' ? controller[0].text : controller[1].text;
          String password =
              page == 'home' ? controller[1].text : controller[3].text;
          if (page == "home") {
            await userLogin(context: context, email: email, password: password);
          } else {
            String name = controller[0].text;
            String phone = controller[3].text;
            await newuserLogin(
                context: context,
                name: name,
                phone: phone,
                email: email,
                password: password);
          }
        }
      },
      child: GetBuilder<SubmitButtonGetx>(
        builder: (controller) {
          return controller.loadingtextWidget(text: buttonname);
        },
      ),
    ),
  );
}






