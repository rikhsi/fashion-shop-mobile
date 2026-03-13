class Validators {
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Verification code is required';
    }

    if (value.length != 6) {
      return 'Verification code must be 6 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Verification code must contain only digits';
    }

    return null;
  }
}
