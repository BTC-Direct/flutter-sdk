import 'dart:math';

import 'package:btcdirect/src/presentation/config_packages.dart';

class AppCommonFunction {
  String chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

  String generateRandomString(int length) {
    final random = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  successSnackBar({required String message, required BuildContext context}) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  failureSnackBar({required String message, required BuildContext context}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: AppColors.white, fontFamily: 'TextaAlt', fontSize: 18, fontWeight: FontWeight.w400),
      ),
      duration: const Duration(seconds: 4),
      backgroundColor: AppColors.redColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future getJsonData() async {
    final jsonData = await rootBundle.loadString('assets/error_json_code.json');
    //debugPrint("JSONDATA ::: $jsonData");
    ErrorCodeModel newResponse = ErrorCodeModel.fromJson(json.decode(jsonData));
    return newResponse.errorCodeList;
  }

  String truncateStringWithEllipsis(String input, int leftLength, int rightLength) {
    if (input.length <= leftLength + rightLength) {
      return input;
    }

    String leftPart = input.substring(0, leftLength);
    String rightPart = input.substring(input.length - rightLength);

    return '$leftPart...$rightPart';
  }
}