import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split/firebase_options.dart';
import 'package:split/presentation/pages/home_page/home_screen.dart';
import 'package:split/presentation/pages/login_page/login_page.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'Roboto',
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? const HomeScreen()
          : LoginPage(),
    );
  }
}
