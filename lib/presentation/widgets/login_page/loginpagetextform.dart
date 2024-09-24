import 'package:flutter/material.dart';
import 'package:split/presentation/controllers/login_page/validation_functions_controller.dart';
import 'package:split/presentation/controllers/login_page/visibility_getx.dart';

TextFormField loginpagetextformfeild({
  required String name,
  required TextEditingController controller,
  required String? Function(String?) validation,
  bool password = false,
  VisibilityGetx? visibilitycallback, // Accept the callback
}) {
  bool obscureText =
      visibilitycallback?.obscureText ?? false; // Use null-aware operator
  TextInputType? textInputType() {
    if (validation == validatePhoneNumber) {
      return TextInputType.phone;
    } else if (validation == validateEmail) {
      return TextInputType.emailAddress;
    }
    return null;
  }

  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: textInputType(),
    obscureText: obscureText,
    controller: controller,
    validator: validation,
    decoration: InputDecoration(
      suffixIcon: password
          ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                visibilitycallback?.OnTap(); // Toggle the visibility
              },
            )
          : null,
      labelStyle: const TextStyle(color: Colors.grey),
      labelText: name,
      fillColor: Colors.grey.shade200,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
    ),
  );
}
