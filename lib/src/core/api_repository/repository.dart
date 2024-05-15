import 'dart:developer';

import 'package:btcdirect/src/features/buy/ui/buy.dart';
import 'package:btcdirect/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;

class Repository {
  static var client = http.Client();
  String baseUrl = isSendBox ? "https://api-sandbox.btcdirect.eu/api/" : "https://api.btcdirect.eu/api/";

  getClientInfoApiCall() async {
    try {
      http.Response response = await http.get(Uri.parse("${baseUrl}v2/client/info"), headers: {"X-Api-Key": xApiKey});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  getCoinDataListApiCall() async {
    try {
      http.Response response = await http.get(Uri.parse("${baseUrl}v1/system/currency-pairs"), headers: {"X-Api-Key": xApiKey});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  getPaymentMethodApiCall() async {
    try {
      http.Response response = await http.get(Uri.parse("${baseUrl}v1/buy/payment-methods"), headers: {"X-Api-Key": xApiKey});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  getSystemInfoApiCall() async {
    try {
      http.Response response = await http.get(Uri.parse("${baseUrl}v1/system/info"), headers: {"X-Api-Key": xApiKey});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  getUserInfoApiCall(String token, BuildContext context) async {
    try {
      http.Response response = await http.get(Uri.parse("${baseUrl}v1/user/info"), headers: {
        "User-Authorization": "Bearer $token",
        "X-Api-Key": xApiKey,
      });
      var tempData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return tempData;
      } else {
        log("Response ${tempData.toString()}");
        for (int j = 0; j < tempData['errors'].length; j++) {
          if (tempData['errors'].keys.toList()[j] == "ER701") {
            getNewTokenApiCall(context);
          } else {
            var errorCodeList = await AppCommonFunction().getJsonData();
            for (int i = 0; i < errorCodeList.length; i++) {
              if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
                AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
                log("${errorCodeList[i].message}");
              }
            }
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  getPriceApiCall() async {
    http.Response response = await http.get(Uri.parse("${baseUrl}v1/prices"), headers: {"X-Api-Key": xApiKey});
    var tempData = jsonDecode(response.body) as Map<String, dynamic>;
    return tempData;
  }

  createAccountApiCall(
    BuildContext context,
    String identifier,
    String firstName,
    String lastName,
    String email,
    String password,
    String nationalityCode,
    bool isBusiness,
    bool newsletterSubscription,
  ) async {
    http.Response response = await http.post(Uri.parse("${baseUrl}v2/user"), body: {
      "isBusiness": isBusiness.toString(),
      "identifier": identifier,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "country": nationalityCode,
      "password": password,
      "termsAndConditions": "true",
      "privacyAgreement": "true",
      "newsletterSubscription": newsletterSubscription.toString(),
      "websiteLanguage": "en",
      "websiteCountry": "gb"
    }, headers: {
      "X-Api-Key": xApiKey,
    });
    return response;
  }

  identifierGetVerificationCodeApiCall(String emailCode, String identifier) async {
    http.Response response = await http.patch(Uri.parse("${baseUrl}v2/user"), body: {
      "emailCode": emailCode
    }, headers: {
      "X-Api-Key": xApiKey,
      "user-identifier": identifier,
    });
    return response;
  }

  identifierDetReSendEmailApiCall(String email, String identifier) async {
    http.Response response = await http.patch(Uri.parse("${baseUrl}v2/user"), body: {
      "email": email
    }, headers: {
      "X-Api-Key": xApiKey,
      "user-identifier": identifier,
    });
    return response;
  }

  tokenGetVerificationCodeApiCall(String emailCode) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response =
        await http.patch(Uri.parse("${baseUrl}v2/user"), body: {"emailCode": emailCode}, headers: {"X-Api-Key": xApiKey, "User-Authorization": "Bearer $token"});
    return response;
  }

  tokenDetReSendEmailApiCall(String email) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response = await http.patch(Uri.parse("${baseUrl}v2/user"), body: {"email": email}, headers: {"X-Api-Key": xApiKey, "User-Authorization": "Bearer $token"});
    return response;
  }

  getOnAmountChangedApiCall(Object body) async {
    http.Response response = await http.post(Uri.parse("${baseUrl}v1/buy/quote"), headers: {"X-Api-Key": xApiKey}, body: body);
    return response;
  }

  getVerificationStatusApiCall(BuildContext context) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    var identifier = StorageHelper.getValue(StorageKeys.identifier);
    var response;
    if (identifier != null && token == null ) {
      debugPrint("identifier=== = $identifier");
      response = await http.get(Uri.parse("${baseUrl}v2/user/verification-status"), headers: {"X-Api-Key": xApiKey, "User-Identifier": identifier});
    } else {
      debugPrint("token=== = $token");
      response = await http.get(Uri.parse("${baseUrl}v2/user/verification-status"), headers: {"X-Api-Key": xApiKey, "User-Authorization": "Bearer $token"});
    }
    if (response.statusCode == 200) {
      return response;
    } else {
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        if (tempData['errors'].keys.toList()[j] == "ER701") {
          getNewTokenApiCall(context).then((value) {
            getVerificationStatusApiCall(context);
          });
        } else {
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
            }
          }
        }
      }
    }
  }

  signInAccountApiCall(String email, String password, BuildContext context) async {
    http.Response response = await http.post(Uri.parse("${baseUrl}v1/user/login"), body: {
      "emailAddress": email,
      "password": password,
    }, headers: {
      "X-Api-Key": xApiKey,
    });
    if (response.statusCode == 200) {
      return response;
    } else {
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        var errorCodeList = await AppCommonFunction().getJsonData();
        for (int i = 0; i < errorCodeList.length; i++) {
          if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
            AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
          }
        }
      }
    }
  }

  getQuoteApiCall(Object body, BuildContext context) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response = await http.post(Uri.parse("${baseUrl}v1/buy/quote"), headers: {"X-Api-Key": xApiKey, "User-Authorization": "Bearer $token"}, body: body);
    if (response.statusCode == 200) {
      return response;
    } else {
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        if (tempData['errors'].keys.toList()[j] == "ER701") {
          getNewTokenApiCall(context).then((value) {
            getQuoteApiCall(body, context);
          });
        } else {
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
            }
          }
        }
      }
    }
  }

  getPaymentConfirmApiCall(Object body, String token, BuildContext context) async {
    http.Response response = await http.post(Uri.parse("${baseUrl}v1/buy/confirm"), headers: {"X-Api-Key": xApiKey, "User-Authorization": "Bearer $token"}, body: body);
    if (response.statusCode == 201) {
      return response;
    } else {
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        if (tempData['errors'].keys.toList()[j] == "ER701") {
          getNewTokenApiCall(context).then((value) {
            getPaymentConfirmApiCall(body, token, context);
          });
        } else {
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
            }
          }
        }
      }
    }
  }

  getOrderDataApiCall(String orderId, BuildContext context) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response = await http.get(
      Uri.parse("${baseUrl}v1/user/buy/orders/$orderId"),
      headers: {"X-Api-Key": xApiKey, "User-Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        if (tempData['errors'].keys.toList()[j] == "ER701") {
          getNewTokenApiCall(context).then((value) {
            getOrderDataApiCall(orderId, context);
          });
        } else {
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
            }
          }
        }
      }
    }
  }

  Future getNewTokenApiCall(BuildContext context) async {
    var refreshToken = StorageHelper.getValue(StorageKeys.refreshToken);
    var body = {"refreshToken": refreshToken};
    http.Response response = await http.post(
      Uri.parse("${baseUrl}v1/refresh"),
      headers: {"X-Api-Key": xApiKey},
      body: body,
    );
    var tempData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      StorageHelper.setValue(StorageKeys.token, tempData['token']);
      StorageHelper.setValue(StorageKeys.refreshToken, tempData['refreshToken']);
    } else {
      log("Response ${tempData.toString()}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyScreen(),
        ),
      );
    }
  }
}
