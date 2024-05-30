import 'dart:developer';
import 'package:btc_direct/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;

class Repository {
  static var client = http.Client();
  String baseUrl = isSandBox
      ? "https://api-sandbox.btcdirect.eu/api/"
      : "https://api.btcdirect.eu/api/";

  /// Retrieves information about the client.
  ///
  /// This function sends a GET request to the API endpoint 'v2/client/info' with
  /// the X-Api-Key header. It returns a `http.Response` object that completes when
  /// the client info retrieval is done.
  ///
  /// Returns:
  ///   - A `http.Response` object that completes when the client info retrieval is done.
  getClientInfoApiCall() async {
    try {
      http.Response response = await http.get(
          Uri.parse("${baseUrl}v2/client/info"),
          headers: {"X-Api-Key": xApiKey});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  /// Retrieves a list of currency pairs from the API.
  ///
  /// This function sends a GET request to the API endpoint 'v1/system/currency-pairs'
  /// with the X-Api-Key header. It returns a `http.Response` object that completes
  /// when the currency pairs retrieval is done.
  ///
  /// Returns:
  ///   - A `http.Response` object that completes when the currency pairs retrieval is done.
  getCoinDataListApiCall() async {
    try {
      http.Response response = await http.get(
          Uri.parse("${baseUrl}v1/system/currency-pairs"),
          headers: {"X-Api-Key": xApiKey});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  /// Retrieves the system info from the API.
  ///
  /// This function sends a GET request to the API endpoint 'v1/system/info'
  /// with the X-Api-Key header. It returns a `http.Response` object that completes
  /// when the system info retrieval is done.
  ///
  /// Returns:
  ///   - A `http.Response` object that completes when the system info retrieval is done.
  getSystemInfoApiCall() async {
    try {
      http.Response response = await http.get(
          Uri.parse("${baseUrl}v1/system/info"),
          headers: {"X-Api-Key": xApiKey});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  /// Retrieves the user info from the API.
  ///
  /// This function sends a GET request to the API endpoint 'v1/user/info'
  /// with the X-Api-Key and Authorization headers. It returns the response
  /// body as a map. If the response status code is 200, it returns the response
  /// body. If the response status code is not 200, it logs the response body and
  /// shows the appropriate error message using the `failureSnackBar` function
  /// from the AppCommonFunction class. If the error code is ER701, it calls the
  /// `getNewTokenApiCall` function to refresh the token.
  ///
  /// Parameters:
  ///   - `token`: The token which is used to authenticate the API call.
  ///   - `context`: The build context used for navigation.
  ///
  /// Returns:
  ///   - A map containing the user info if the response status code is 200.
  ///   - Otherwise, null.
  getUserInfoApiCall(String token, BuildContext context) async {
    http.Response response;
    try {
      var identifier = await StorageHelper.getValue(StorageKeys.identifier);
      if (identifier != null && (token == "" || token.isEmpty)) {
        response = await http.get(Uri.parse("${baseUrl}v1/user/info"),
            headers: {"X-Api-Key": xApiKey, "User-Identifier": identifier});
      } else {
        response =
            await http.get(Uri.parse("${baseUrl}v1/user/info"), headers: {
          "User-Authorization": "Bearer $token",
          "X-Api-Key": xApiKey,
        });
      }
      if (response.statusCode == 200) {
        return response;
      } else {
        var tempData = jsonDecode(response.body);
        log("Response ${tempData.toString()}");
        for (int j = 0; j < tempData['errors'].length; j++) {
          if (tempData['errors'].keys.toList()[j] == "ER701") {
            if (context.mounted) {
              getNewTokenApiCall(context);
            }
          } else {
            var errorCodeList = await AppCommonFunction().getJsonData();
            for (int i = 0; i < errorCodeList.length; i++) {
              if (errorCodeList[i].code ==
                  tempData['errors'].keys.toList()[j]) {
                if (context.mounted) {
                  AppCommonFunction().failureSnackBar(
                      context: context, message: '${errorCodeList[i].message}');
                }
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

  /// Fetches the current prices of the supported currencies from the API and returns the response body as a map.
  ///
  /// The function calls the `getPriceApiCall` function from the API and decodes the response body into a map.
  /// The function then returns the map.
  ///
  /// [return]: The response body as a map.
  getPriceApiCall() async {
    http.Response response = await http
        .get(Uri.parse("${baseUrl}v1/prices"), headers: {"X-Api-Key": xApiKey});
    var tempData = jsonDecode(response.body) as Map<String, dynamic>;
    return tempData;
  }

  /// Calls the API to create a new user account.
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
    http.Response response = await http.post(Uri.parse("${baseUrl}v2/user"),
        body: jsonEncode({
          "isBusiness": isBusiness,
          "identifier": identifier,
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "country": nationalityCode,
          "password": password,
          "termsAndConditions": true,
          "privacyAgreement": true,
          "newsletterSubscription": newsletterSubscription,
          "websiteLanguage": "en",
          "websiteCountry": "gb"
        }),
        headers: {
          "X-Api-Key": xApiKey,
        });
    return response;
  }

  /// Calls the API to send the email verification code to the user.
  ///
  /// This function sends a PATCH request to the API endpoint 'v2/user'
  /// with the email code as the request body. It expects a JSON response
  /// containing the updated user information. If the response status code is 200,
  /// it returns the response object. If the response status code is not 200,
  identifierGetVerificationCodeApiCall(
      String emailCode, String identifier) async {
    http.Response response = await http.patch(Uri.parse("${baseUrl}v2/user"),
        body: jsonEncode({"emailCode": emailCode}),
        headers: {
          "X-Api-Key": xApiKey,
          "user-identifier": identifier,
        });
    return response;
  }

  /// Calls the API to re-send the email verification code to the user.
  ///
  /// This function sends a PATCH request to the API endpoint 'v2/user'
  /// with the email address as the request body. It expects a JSON response
  /// containing the updated user information. If the response status code is 200,
  /// it returns the response object. If the response status code is not 200,
  /// it logs the response body.
  ///
  /// Parameters:
  ///   - `email`: The email address to re-send the verification code to.
  ///   - `identifier`: The user identifier of the user to re-send the email code to.
  ///
  /// Returns:
  ///   - A `http.Response` object that completes when the email re-sending is done.
  identifierDetReSendEmailApiCall(String email, String identifier) async {
    http.Response response = await http.patch(Uri.parse("${baseUrl}v2/user"),
        body: jsonEncode({"email": email}),
        headers: {
          "X-Api-Key": xApiKey,
          "user-identifier": identifier,
        });
    return response;
  }

  /// Calls the API to verify the email code sent to the user's email.
  ///
  /// This function sends a PATCH request to the API endpoint 'v2/user' with the email
  /// verification code as the request body. It expects a JSON response containing
  /// the updated user information. If the response status code is 200, it returns
  /// the response object. If the response status code is not 200, it logs the
  /// response body.
  ///
  /// Parameters:
  ///   - `emailCode`: The email verification code entered by the user.
  ///
  /// Returns:
  ///   - A `http.Response` object that completes when the email verification is done.
  tokenGetVerificationCodeApiCall(String emailCode) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response = await http.patch(Uri.parse("${baseUrl}v2/user"),
        body: jsonEncode({"emailCode": emailCode}),
        headers: {"X-Api-Key": xApiKey, "User-Authorization": "Bearer $token"});
    return response;
  }

  /// Calls the API to re-send the email verification code to the user.
  ///
  /// This function sends a PATCH request to the API endpoint 'v2/user'
  /// with the email address as the request body. It expects a JSON response
  /// containing the updated user details. If the response status code is 202,
  /// it updates the stored token, user id, and refresh token in the shared
  /// preferences. If the response status code is not 202, it logs the
  /// response body.
  ///
  /// Parameters:
  ///   - `email`: The email address of the user.
  tokenDetReSendEmailApiCall(String email) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response = await http.patch(Uri.parse("${baseUrl}v2/user"),
        body: jsonEncode({"email": email}),
        headers: {"X-Api-Key": xApiKey, "User-Authorization": "Bearer $token"});
    return response;
  }

  /// Calls the API to get an on-amount changed quote.
  ///
  /// This function sends a POST request to the API endpoint 'v1/buy/quote'
  /// with the on-amount changed request body. It expects a JSON response
  /// containing the quote details. If the response status code is 200, it
  /// returns the response object.
  ///
  /// Parameters:
  ///   - `body`: The on-amount changed request body.
  ///
  /// Returns:
  ///   - A `http.Response` object that completes when the quote retrieval is done.
  Future<http.Response> getOnAmountChangedApiCall(Object body) async {
    http.Response response = await http.post(
        Uri.parse("${baseUrl}v1/buy/quote"),
        headers: {"X-Api-Key": xApiKey},
        body: jsonEncode(body));
    return response;
  }

  /// Calls the API to get the verification status of the user.
  getVerificationStatusApiCall(BuildContext context) async {
    var token = await StorageHelper.getValue(StorageKeys.token);
    var identifier = await StorageHelper.getValue(StorageKeys.identifier);
    http.Response response;
    if (identifier != null && (token == null || token == "" || token.isEmpty)) {
      response = await http.get(
          Uri.parse("${baseUrl}v2/user/verification-status"),
          headers: {"X-Api-Key": xApiKey, "User-Identifier": identifier});
    } else {
      response = await http
          .get(Uri.parse("${baseUrl}v2/user/verification-status"), headers: {
        "X-Api-Key": xApiKey,
        "User-Authorization": "Bearer $token"
      });
    }
    if (response.statusCode == 200) {
      return response;
    } else {
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        if (tempData['errors'].keys.toList()[j] == "ER701") {
          if (context.mounted) {
            getNewTokenApiCall(context).then((value) {
              getVerificationStatusApiCall(context);
            });
          }
        } else {
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
            }
          }
        }
      }
    }
  }

  /// Calls the API to sign in the user.
  signInAccountApiCall(
      String email, String password, BuildContext context) async {
    http.Response response =
        await http.post(Uri.parse("${baseUrl}v1/user/login"),
            body: jsonEncode({
              "emailAddress": email,
              "password": password,
            }),
            headers: {
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
            if (context.mounted) {
              AppCommonFunction().failureSnackBar(
                  context: context, message: '${errorCodeList[i].message}');
            }
          }
        }
      }
    }
  }

  /// Calls the API to get an on-amount changed quote.
  getQuoteApiCall(Object body, BuildContext context) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response = await http.post(
        Uri.parse("${baseUrl}v1/buy/quote"),
        headers: {"X-Api-Key": xApiKey, "User-Authorization": "Bearer $token"},
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      return response;
    } else {
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        if (tempData['errors'].keys.toList()[j] == "ER701") {
          if (context.mounted) {
            getNewTokenApiCall(context).then((value) {
              getQuoteApiCall(body, context);
            });
          }
        } else {
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
            }
          }
        }
      }
    }
  }

  /// Confirms a payment to the API.
  ///
  /// This function sends a POST request to the API endpoint 'v1/buy/confirm' with
  /// the given `body` and a Bearer token. It expects a JSON response containing
  /// order data. If the response status code is 201, it returns the response.
  /// If the response status code is not 201, it logs the response body and
  /// checks the error codes. If the error code is ER701, it calls
  /// `getNewTokenApiCall` to refresh the token and then calls this function
  /// again. If the error code is not ER701, it shows a snackbar with the error
  /// message.
  ///
  /// Parameters:
  ///   - `body`: The body of the POST request.
  ///   - `token`: The token to use in the Authorization header.
  ///   - `context`: The build context used for navigation.
  getPaymentConfirmApiCall(
      Object body, String token, BuildContext context) async {
    http.Response response = await http.post(
        Uri.parse("${baseUrl}v1/buy/confirm"),
        headers: {"X-Api-Key": xApiKey, "User-Authorization": "Bearer $token"},
        body: jsonEncode(body));
    if (response.statusCode == 201) {
      return response;
    } else {
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        if (tempData['errors'].keys.toList()[j] == "ER701") {
          if (context.mounted) {
            getNewTokenApiCall(context).then((value) {
              getPaymentConfirmApiCall(body, token, context);
            });
          }
        } else {
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
            }
          }
        }
      }
    }
  }

  /// Retrieves order data from the API by order ID.
  ///
  /// This function sends a GET request to the API endpoint
  /// 'v1/user/buy/orders/<orderId>' with a Bearer token. It expects a JSON
  /// response containing order data. If the response status code is 200, it
  /// returns the response. If the response status code is not 200, it logs
  /// the response body and checks the error codes. If the error code is
  /// ER701, it calls `getNewTokenApiCall` to refresh the token and then
  /// calls this function again with the same order ID. If the error code is
  /// not ER701, it shows the appropriate error message using the
  /// `failureSnackBar` function from the AppCommonFunction class.
  ///
  /// Parameters:
  ///   - `orderId`: The ID of the order to retrieve.
  ///   - `context`: The build context used for navigation.
  ///
  /// Returns:
  ///   - A `Future` that completes when the order data is retrieved.
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
          if (context.mounted) {
            getNewTokenApiCall(context).then((value) {
              getOrderDataApiCall(orderId, context);
            });
          }
        } else {
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
            }
          }
        }
      }
    }
  }

  /// Retrieves a new token from the API by refreshing the existing refresh token.
  ///
  /// This function sends a POST request to the API endpoint 'v1/refresh' with the
  /// refresh token as the request body. It expects a JSON response containing a
  /// new token and a new refresh token. If the response status code is 200, it
  /// updates the stored token and refresh token in the shared preferences. If the
  /// response status code is not 200, it logs the response body.
  ///
  /// Parameters:
  ///   - `context`: The build context used for navigation.
  ///
  /// Returns:
  ///   - A `Future` that completes when the token retrieval is done.
  Future getNewTokenApiCall(BuildContext context) async {
    var refreshToken = StorageHelper.getValue(StorageKeys.refreshToken);
    var body = jsonEncode({"refreshToken": refreshToken});
    http.Response response = await http.post(
      Uri.parse("${baseUrl}v1/refresh"),
      headers: {"X-Api-Key": xApiKey},
      body: body,
    );
    var tempData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      StorageHelper.setValue(StorageKeys.token, tempData['token']);
      StorageHelper.setValue(
          StorageKeys.refreshToken, tempData['refreshToken']);
    } else {
      log("Response ${tempData.toString()}");
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const SignIn(),
      //   ),
      // );
    }
  }

  Future currencyPriceGetModelApiCall(BuildContext context) async {
    http.Response response;
    response = await http
        .get(Uri.parse("${baseUrl}v1/system/currency-pairs"), headers: {
      "X-Api-Key": xApiKey,
    });
    if (response.statusCode == 200) {
      return response;
    } else {
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        if (tempData['errors'].keys.toList()[j] == "ER701") {
          if (context.mounted) {
            getNewTokenApiCall(context).then((value) {
              getVerificationStatusApiCall(context);
            });
          }
        } else {
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
            }
          }
        }
      }
    }
  }

  /// Retrieves the payment methods from the API.
  ///
  /// This function sends a GET request to the API endpoint 'v1/buy/payment-methods'
  /// with the X-Api-Key header. It returns a `http.Response` object that completes
  /// when the payment methods retrieval is done.
  ///
  /// Returns:
  ///   - A `http.Response` object that completes when the payment methods retrieval is done.
  Future getPaymentMethodApiCall(BuildContext context) async {
    http.Response response;
    response = await http.get(
        Uri.parse("${baseUrl}v1/buy/payment-methods/$paymentMethods"),
        headers: {
          "X-Api-Key": xApiKey,
        });
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('getPaymentMethodsApiCall ::: ***${response.body}***');
      }
      return response;
    } else {
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        if (tempData['errors'].keys.toList()[j] == "ER701") {
          if (context.mounted) {
            getNewTokenApiCall(context).then((value) {
              getVerificationStatusApiCall(context);
            });
          }
        } else {
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
            }
          }
        }
      }
    }
  }

  /// Calls the API to send the setQuestionAnswerApiCall verification code to the user.
  ///
  /// This function sends a PATCH request to the API endpoint 'v2/user'
  /// with the email code as the request body. It expects a JSON response
  /// containing the updated user information. If the response status code is 200,
  /// it returns the response object. If the response status code is not 200,
  setQuestionAnswerApiCall(
      {required String origin,
      required String employmentStatus,
      required String income}) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    var identifier = await StorageHelper.getValue(StorageKeys.identifier);
    http.Response response;
    if (identifier != null && (token == null || token == "" || token.isEmpty)) {
      response = await http.patch(
        Uri.parse("${baseUrl}v2/user"),
        headers: {"X-Api-Key": xApiKey, "User-Identifier": identifier},
        body: jsonEncode({
          "amld5QuestionAnswers": {
            "kyc-amld5-annual-net-income": income.trim(),
            "kyc-amld5-employment-status": employmentStatus.trim(),
            "kyc-amld5-main-source-income": origin.trim()
          }
        }),
      );
    } else {
      response = await http.patch(
        Uri.parse("${baseUrl}v2/user"),
        headers: {"X-Api-Key": xApiKey, "User-Authorization": "Bearer $token"},
        body: jsonEncode({
          "amld5QuestionAnswers": {
            "kyc-amld5-annual-net-income": income.trim(),
            "kyc-amld5-employment-status": employmentStatus.trim(),
            "kyc-amld5-main-source-income": origin.trim()
          }
        }),
      );
    }
    return response;
  }
}
