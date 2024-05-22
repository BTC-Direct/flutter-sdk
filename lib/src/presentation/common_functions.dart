import 'dart:math';

import 'package:btc_direct/src/presentation/config_packages.dart';

class AppCommonFunction {
  String chars =
      "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

  /// Generates a random string of the specified length.
  ///
  /// The function uses the `Random` class to generate random integers within the range of the length of the `chars` string.
  /// It then converts each random integer into a character using the `codeUnitAt` method of the `chars` string.
  /// Finally, it concatenates all the characters into a single string and returns it.
  ///
  /// Parameters:
  /// - `length`: The length of the random string to be generated.
  ///
  /// Returns:
  /// A random string of the specified length.
  String generateRandomString(int length) {
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  successSnackBar({required String message, required BuildContext context}) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  failureSnackBar({required String message, required BuildContext context}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
            color: CommonColors.white,
            fontFamily: 'TextaAlt',
            package: "btc_direct",
            fontSize: 18,
            fontWeight: FontWeight.w400),
      ),
      duration: const Duration(seconds: 4),
      backgroundColor: CommonColors.redColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Retrieves the error code list from the error code JSON file.
  ///
  /// This function loads the error code JSON file located at 'packages/btc_direct/assets/error_json_code.json'
  /// and parses it into a `ErrorCodeModel` object. It then returns the `errorCodeList` property of the
  /// `ErrorCodeModel` object.
  ///
  /// Returns a `Future<List<ErrorCode>>` that resolves to the list of error codes.
  Future getJsonData() async {
    final jsonData = await rootBundle
        .loadString('packages/btc_direct/assets/error_json_code.json');
    //debugPrint("JSONDATA ::: $jsonData");
    ErrorCodeModel newResponse = ErrorCodeModel.fromJson(json.decode(jsonData));
    return newResponse.errorCodeList;
  }

  /// Truncates a string with ellipsis if it exceeds the specified length.
  ///
  /// The [input] parameter is the string to be truncated.
  /// The [leftLength] parameter specifies the length of the left part of the string to be retained.
  /// The [rightLength] parameter specifies the length of the right part of the string to be retained.
  ///
  /// Returns the truncated string with ellipsis if the length exceeds [leftLength] + [rightLength].
  /// Otherwise, returns the original string.
  String truncateStringWithEllipsis(
      String input, int leftLength, int rightLength) {
    if (input.length <= leftLength + rightLength) {
      return input;
    }

    String leftPart = input.substring(0, leftLength);
    String rightPart = input.substring(input.length - rightLength);

    return '$leftPart...$rightPart';
  }

  /// Retrieves the current date and time in Central European Time (CET).
  ///
  /// This function converts the current UTC date and time to CET by adding one hour to the UTC time.
  ///
  /// Returns a `DateTime` object representing the current date and time in CET.
  DateTime getCETDateTime() {
    var now = DateTime.now().toUtc();
    var cetOffset = const Duration(hours: 1);
    var cetTime = now.add(cetOffset);
    return cetTime;
  }
}
