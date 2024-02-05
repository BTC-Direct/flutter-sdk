class FieldValidator {
  static String? validatePassword(String? value, {required String text, required String validText}) {
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.isEmpty) {
      return text;
    } else if (!regex.hasMatch(value)) {
      return validText;
    }
    return null;
  }

  static String? validateValueIsEmpty(String? value, String text) {
    if (value!.isEmpty) {
      return text;
    }
    return null;
  }
}
