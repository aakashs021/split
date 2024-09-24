import 'package:flutter/material.dart';
import 'package:split/presentation/widgets/login_page/or_text_wiget_divider.dart';

Widget orWidget() {
  return Row(
    children: [
      orWidgetDivider(),
      const SizedBox(width: 10),
      const Text('or'),
      const SizedBox(width: 10),
      orWidgetDivider()
    ],
  );
}