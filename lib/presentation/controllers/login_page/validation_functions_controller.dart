String? validatename(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }

  String pattern = r'^[^@]+@[^@]+\.[^@]+';
  RegExp regex = RegExp(pattern);

  if (!regex.hasMatch(value)) {
    return 'Please enter a valid email';
  }

  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }

  // Regex pattern for phone number validation (10 digits)
  String pattern = r'^\d{10}$';
  RegExp regex = RegExp(pattern);

  if (!regex.hasMatch(value)) {
    return 'Please enter a valid 10-digit phone number';
  }

  return null;
}
