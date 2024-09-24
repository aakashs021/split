import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split/presentation/controllers/login_page/validation_functions_controller.dart';
import 'package:split/presentation/controllers/login_page/visibility_getx.dart';
import 'package:split/presentation/pages/login_page/login_page.dart';
import 'package:split/presentation/widgets/login_page/login_button.dart';
import 'package:split/presentation/widgets/login_page/login_textbutton.dart';
import 'package:split/presentation/widgets/login_page/loginpagetextform.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final formkey = GlobalKey<FormState>();

 final List<TextEditingController> controller = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final visibilityController = Get.put(VisibilityGetx(), tag: 'signup');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  color: Colors.black,
                  Icons.lock,
                  size: 200,
                ),
                const SizedBox(height: 30),
                loginpagetextformfeild(
                    name: "Name",
                    controller: controller[0],
                    validation: validatename),
                const SizedBox(height: 15),
                loginpagetextformfeild(
                    name: "Email",
                    controller: controller[1],
                    validation: validateEmail),
                const SizedBox(height: 15),
                loginpagetextformfeild(
                    name: "Phone number",
                    controller: controller[2],
                    validation: validatePhoneNumber),
                const SizedBox(height: 15),
                GetBuilder<VisibilityGetx>(
                  builder: (visibility) {
                    return loginpagetextformfeild(
                      name: "Password",
                      visibilitycallback: visibility,
                      controller: controller[3],
                      validation: validatename,
                      password: true,
                    );
                  },
                ),
                const SizedBox(height: 15),
                loginButton(context: context,
                    formkey: formkey, controller: controller, page: 'signup'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textbuttons(
                        context: context,
                        text: 'Alredy have an account? Sign in',
                        navpage: LoginPage()),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
