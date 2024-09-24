import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:split/presentation/controllers/login_page/new_user_login_controller.dart';
import 'package:split/presentation/controllers/login_page/validation_functions_controller.dart';
import 'package:split/presentation/controllers/login_page/visibility_getx.dart';
import 'package:split/presentation/pages/home_page/home_screen.dart';
import 'package:split/presentation/pages/sign_up_page/signup_page.dart';
import 'package:split/presentation/widgets/login_page/login_button.dart';
import 'package:split/presentation/widgets/login_page/login_textbutton.dart';
import 'package:split/presentation/widgets/login_page/loginpagetextform.dart';
import 'package:split/presentation/widgets/login_page/or_text_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final formkey = GlobalKey<FormState>();

  final List<TextEditingController> controller = List.generate(
    2,
    (index) => TextEditingController(),
  );

  final visibilityController = Get.create(() => VisibilityGetx());

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
                    name: "Email",
                    controller: controller[0],
                    validation: validateEmail),
                const SizedBox(height: 15),
                GetBuilder<VisibilityGetx>(
                  builder: (visibility) {
                    return loginpagetextformfeild(
                      name: "Password",
                      visibilitycallback: visibility,
                      controller: controller[1],
                      validation: validatename,
                      password: true,
                    );
                  },
                ),
                const SizedBox(height: 15),
                loginButton(
                    context: context, formkey: formkey, controller: controller),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textbuttons(
                        context: context,
                        text: 'Forgot password?',
                        navpage:  SignupPage()),
                    textbuttons(
                        context: context,
                        text: 'Sign Up',
                        navpage: SignupPage()),
                  ],
                ),
                orWidget(),
                Align(
                    alignment: Alignment.center,
                    child: InkWell(
                        onTap: () async {
                          await googlesignin();
                        var user=  FirebaseAuth.instance.currentUser!;
                        newGoogleUserLogin(email: user.email!, name: user.displayName!, phone: 'phone');
                          Get.to(()=>const HomeScreen());
                        },
                        child: const Text('Continue with google')))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

googlesignin() async {
  try {
     GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    return await FirebaseAuth.instance.signInWithCredential(cred);
  } on FirebaseAuthException catch (e) {
    print(e.toString());
  }
}
