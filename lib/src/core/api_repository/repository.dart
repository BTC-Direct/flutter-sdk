import 'dart:developer';

import 'package:btcdirect/src/features/buy/ui/buy.dart';
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

  getUserInfoApiCall(String token,BuildContext context) async {
    try {
      http.Response response = await http.get(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/user/info"), headers: {
        "User-Authorization": "Bearer $token",
        "X-Api-Key": xApiKey,
      });
      var tempData = jsonDecode(response.body);
      if(response.statusCode == 200){
        print("getUserInfoApiCall Response ${tempData.toString()}");
        print("getUserInfoApiCall statusCode ${response.statusCode}");
        return tempData;
      } else{
        log("Response ${tempData.toString()}");
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (tempData['errors'].keys.toList()[j] == "ER701") {
              getNewTokenApiCall(context);
            }else{
              var errorCodeList = await AppCommonFunction().getJsonData();
              for (int i = 0; i < errorCodeList.length; i++) {
                if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
                  AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
                  print("${errorCodeList[i].message}");
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
    http.Response response = await http.get(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/prices"), headers: {"X-Api-Key": xApiKey});
    var tempData = jsonDecode(response.body) as Map<String, dynamic>;
    return tempData;
  }

  getOnAmountChangedApiCall(Object body) async {
    http.Response response = await http.post(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/buy/quote"), headers: {"X-Api-Key": xApiKey}, body: body);
    return response;
  }

  signInAccountApiCall(String email,String password,BuildContext context) async {
    http.Response response = await http.post(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/user/login"),
        body: {
      "emailAddress": email,
      "password": password,
    }, headers: {
      "X-Api-Key": xApiKey,
    });
    if(response.statusCode == 200){
      return response;
    } else{
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
              print("${errorCodeList[i].message}");
            }
          }
      }
    }

  }

  getQuoteApiCall(Object body,BuildContext context) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response = await http.post(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/buy/quote"),
        headers: {
      "X-Api-Key": xApiKey,
      "User-Authorization": "Bearer $token"
    }, body: body);
    if(response.statusCode == 200){
      return response;
    } else{
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        if (tempData['errors'].keys.toList()[j] == "ER701") {
          getNewTokenApiCall(context).then((value) {
            getQuoteApiCall(body,context);
          });
        }else{
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
              if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
                AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
                print("${errorCodeList[i].message}");
              }
          }
        }
      }
    }
  }

  getPaymentConfirmApiCall(Object body,String token,BuildContext context) async {
    http.Response response = await http.post(
        Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/buy/confirm"),
        headers: {
          "X-Api-Key": xApiKey,
          "User-Authorization": "Bearer $token"
        },
        body: body
    );
    if(response.statusCode == 201){
      return response;
    } else{
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        if (tempData['errors'].keys.toList()[j] == "ER701") {
          getNewTokenApiCall(context).then((value) {
            getPaymentConfirmApiCall(body,token,context);
          });
        }else{
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
              if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
                AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
                print("${errorCodeList[i].message}");
              }
          }
        }
      }
    }
  }

  getOrderDataApiCall(String orderId,BuildContext context) async {
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response = await http.get(
        Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/user/buy/orders/$orderId"),
        headers: {
          "X-Api-Key": xApiKey,
          "User-Authorization": "Bearer $token"
        },
    );
    if(response.statusCode == 200){
      return response;
    } else{
      var tempData = jsonDecode(response.body);
      log("Response ${tempData.toString()}");
      for (int j = 0; j < tempData['errors'].length; j++) {
        if (tempData['errors'].keys.toList()[j] == "ER701") {
          getNewTokenApiCall(context).then((value) {
            getOrderDataApiCall(orderId,context);
          });
        }else{
          var errorCodeList = await AppCommonFunction().getJsonData();
          for (int i = 0; i < errorCodeList.length; i++) {
              if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
                AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
                print("${errorCodeList[i].message}");
              }
          }
        }
      }
    }
  }

  Future getNewTokenApiCall(BuildContext context) async {
    var refreshToken = StorageHelper.getValue(StorageKeys.refreshToken);
    var body = {
      "refreshToken": refreshToken
    };
    http.Response response = await http.post(
        Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/refresh"),
        headers: {
          "X-Api-Key": xApiKey
        },
      body: body,
    );
    var tempData = jsonDecode(response.body);
    if(response.statusCode == 200){
      StorageHelper.setValue(StorageKeys.token, tempData['token']);
      StorageHelper.setValue(StorageKeys.refreshToken, tempData['refreshToken']);
    }else{
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
