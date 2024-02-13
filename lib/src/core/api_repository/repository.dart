import 'dart:developer';

import 'package:btcdirect/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;

class Repository {
  static var client = http.Client();

  getCoinDataListApiCall() async {
    try {
      http.Response response = await http.get(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/system/currency-pairs"),
          headers: {
        "X-Api-Key": xApiKey
      }
      );
      print("getCurrencyPairsApiCall Response ${response.body.toString()}");
      print("getCurrencyPairsApiCall statusCode ${response.statusCode}");
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  getPaymentMethodApiCall() async {
    try {
      http.Response response = await http.get(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/buy/payment-methods"), headers: {"X-Api-Key": xApiKey});
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  getUserInfoApiCall(String token) async {
    try {
      http.Response response = await http.get(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/user/info"), headers: {
        "User-Authorization": "Bearer $token",
        "X-Api-Key": xApiKey,
      });
      var tempData = jsonDecode(response.body);
      print("getUserInfoApiCall Response ${tempData.toString()}");
      print("getUserInfoApiCall statusCode ${response.statusCode}");
      return tempData;
    } catch (e) {
      log(e.toString());
    }
  }

  getPriceApiCall() async {
    http.Response response = await http.get(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/prices"), headers: {"X-Api-Key": xApiKey});
    var tempData = jsonDecode(response.body) as Map<String, dynamic>;
    return tempData;
  }

  getOnAmountChangedApiCall(Object body) async {
    http.Response response = await http.post(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/buy/quote"), headers: {"X-Api-Key": xApiKey}, body: body);
    return response;
  }

  getQuoteApiCall(Object body) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response = await http.post(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/buy/quote"), headers: {
      "X-Api-Key": xApiKey,
      "User-Authorization": "Bearer $token"
    }, body: body);
    return response;
  }

  getPaymentConfirmApiCall(Object body,String token) async {
    http.Response response = await http.post(
        Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/buy/confirm"),
        headers: {
          "X-Api-Key": xApiKey,
          "User-Authorization": "Bearer $token"
        },
        body: body
    );
    return response;
  }

  getOrderDataApiCall(String orderId) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response = await http.get(
        Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/buy/orders/$orderId"),
        headers: {
          "X-Api-Key": xApiKey,
          "User-Authorization": "Bearer $token"
        },
    );
    return response;
  }


}
