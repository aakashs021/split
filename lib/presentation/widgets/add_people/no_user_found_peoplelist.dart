import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget noUserFoundPeopleList() {
  return Stack(
    alignment: Alignment.topCenter,
    children: [
      const Positioned(top: 50, child: Text('No user found')),
      Lottie.asset('asset/lottie/empty list.json'),
    ],
  );
}