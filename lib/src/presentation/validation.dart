class FieldValidator {
  /// Validates a password string and returns an error message if the password does not meet the specified criteria.
  ///
  /// Parameters:
  /// - `value`: The password string to be validated.
  /// - `text`: The error message to be returned if the password is empty.
  /// - `validText`: The error message to be returned if the password does not meet the specified criteria.
  ///
  /// Returns:
  /// - `String?`: The error message if the password is empty or does not meet the specified criteria, otherwise `null`.
  static String? validatePassword(String? value,
      {required String text, required String validText}) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.isEmpty) {
      return text;
    } else if (!regex.hasMatch(value)) {
      return validText;
    }
    return null;
  }

  /// Validates if a given value is empty and returns an error message if it is.
  ///
  /// Parameters:
  /// - `value`: The value to be validated.
  /// - `text`: The error message to be returned if the value is empty.
  ///
  /// Returns:
  /// - `String?`: The error message if the value is empty, otherwise `null`.
  static String? validateValueIsEmpty(String? value, String text) {
    if (value!.isEmpty) {
      return text;
    }
    return null;
  }
}
