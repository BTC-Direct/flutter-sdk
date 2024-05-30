import 'dart:developer';
import 'package:btc_direct/src/core/model/userinfomodel.dart';
import 'package:btc_direct/src/features/buy/ui/buy.dart';
import 'package:btc_direct/src/features/onboarding/ui/questions_answer/origin_questions.dart';
import 'package:btc_direct/src/presentation/config_packages.dart';
import 'package:flutter_idensic_mobile_sdk_plugin/flutter_idensic_mobile_sdk_plugin.dart';
import 'package:http/http.dart' as http;

class VerifyIdentity extends StatefulWidget {
  const VerifyIdentity({super.key});

  @override
  State<VerifyIdentity> createState() => _VerifyIdentityState();
}

class _VerifyIdentityState extends State<VerifyIdentity> {
  bool isLoading = false;
  bool isWebViewReady = false;
  String kycAccessToken = "";
  SNSMobileSDK? snsMobileSDK;

  //late final WebViewController controller;
  static const maxSeconds = 120;
  int _seconds = maxSeconds;
  Timer? _timer;
  bool isTimerRunning = false;
  bool isIdVerified = false;

  /// Initializes the state of the widget.
  ///
  /// This function calls the parent `initState()` method and then calls the
  /// `getKYCAccessToken()` function with the current `BuildContext` to retrieve
  /// the KYC access token.
  @override
  void initState() {
    super.initState();
    getKYCAccessToken(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
      appBarTitle: isWebViewReady ? "Verify identity" : "",
      isAppBarLeadShow: isIdVerified ? true : false,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: isWebViewReady
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(horizontal: w * 0.06),
              child: isIdVerified
                  ? informationVerify()
                  : Column(
                      children: [
                        SizedBox(
                          height: h * 0.09,
                        ),
                        Center(
                            child: Image.asset(
                          Images.verifyDocumentIcon,
                          height: h * 0.25,
                          width: w * 0.5,
                        )),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        const Text(
                          'Verify your identity',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: CommonColors.black,
                            fontFamily: 'TextaAlt',
                          ),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        const Text(
                          "Based on European legislation, BTC Direct is obliged to verify your identity. Complete your verification by uploading a valid ID card, driver's licence or passport.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: CommonColors.greyColor,
                            fontFamily: 'TextaAlt',
                          ),
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        InkWell(
                          onTap: () {
                            bottomSheet(context);
                          },
                          child: const Text(
                            "I don't have my ID with me ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: CommonColors.blueColor,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                        ),
                        const Spacer(),
                        CommonButtonItem.filled(
                          text: "Continue",
                          fontSize: 20,
                          textStyle: const TextStyle(
                            fontSize: 24,
                            color: CommonColors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'TextaAlt',
                          ),
                          bgColor: CommonColors.blueColor,
                          onPressed: () {
                            setState(() {
                              if (kycAccessToken.isNotEmpty ||
                                  kycAccessToken != "") {
                                launchSDK(context);
                              }
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.13,
                        ),
                      ],
                    ),
            ),
    );
  }

  informationVerify() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: h * 0.01,
        ),
        Center(
            child: Image.asset(
          Images.clock,
          height: h * 0.2,
          fit: BoxFit.fill,
        )),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.08,
          ),
          child: const Text(
            "Great, you have done your part.We'll do the rest.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: CommonColors.black,
              fontFamily: 'TextaAlt',
              package: 'btc_direct',
            ),
          ),
        ),
        SizedBox(
          height: h * 0.01,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: h * 0.01),
          child: const Text(
            'We need to verify your information. This can take\nup to 2 minutes. You can leave this screen open or\ncan continue after receiving the confirmation\nemail.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: CommonColors.black,
              fontFamily: 'TextaAlt',
              package: 'btc_direct',
            ),
          ),
        ),
        SizedBox(
          height: h * 0.03,
        ),
        CommonButtonItem.filled(
          text: "Continue - $minutes:$seconds",
          textStyle: const TextStyle(
            fontSize: 20,
            color: CommonColors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'TextaAlt',
          ),
          bgColor: isTimerRunning
              ? CommonColors.greyColor.withOpacity(0.3)
              : CommonColors.blueColor,
          onPressed: isTimerRunning ? null : () {},
        ),
      ],
    );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        isTimerRunning = true;
        _seconds--;
        setState(() {});
      } else {
        _timer?.cancel();
        _seconds = maxSeconds;
        getKYCAccessToken(context);
        setState(() {});
      }
    });
  }

  /// Retrieves the KYC access token from the server.
  getKYCAccessToken(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      http.Response response =
          await Repository().getVerificationStatusApiCall(context);
      var tempData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (tempData == null || tempData.length == [] || tempData.isEmpty) {
          var list = await StorageHelper.getValue(StorageKeys.myAddressesList);
          final List<Map<String, dynamic>> jsonList = jsonDecode(list);

          var xApiKey = await StorageHelper.getValue(StorageKeys.xApiKey);
          var isSandBox = await StorageHelper.getValue(StorageKeys.isSandBox);
          isLoading = false;
          setState(() {});
          if (context.mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BTCDirect(
                    myAddressesList: jsonList,
                    xApiKey: xApiKey,
                    isSandBox: isSandBox,
                  ),
                ));
          }
        } else {
          var kycIndex =
              tempData.indexWhere((element) => element['name'] == "kyc");
          if (kycIndex >= 0) {
            if (tempData[kycIndex]['status'] == 'pending') {
              isIdVerified = true;
              startTimer();
            }
            setState(() {
              isLoading = false;
            });
            kycAccessToken = tempData[kycIndex]['data']['accessToken'];
            log('kycAccessToken $kycAccessToken');
          } else {
            var i = tempData.indexWhere(
                (element) => element['name'] == "amld5QuestionAnswers");
            if (i >= 0) {
              if (tempData[i]['status'] == 'open' ||
                  tempData[i]['status'] == 'missing' ||
                  tempData[i]['status'] == 'pending') {
                setState(() {
                  isLoading = false;
                });
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OriginQuestions(),
                    ),
                  );
                }
              }
            }
          }
        }
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode >= 400) {
        log("Response ${tempData.toString()}");
        setState(() {
          isLoading = false;
        });
        var errorCodeList = await AppCommonFunction().getJsonData();
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
              log(errorCodeList[i].message);
            }
          }
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log(e.toString());
    }
  }

  /// Launches the SDK with the given [context].
  ///
  /// This function initializes the SDK with the provided [accessToken] and
  /// [onTokenExpiration] callback. It then builds the SDK with the specified
  /// locale and debug mode. The SDK is launched and the result is checked.
  /// If the launch is successful and the token is not empty, the current
  /// screen is popped. If the token is empty, the user is navigated to the
  /// sign-in screen.
  ///
  /// Parameters:
  ///   - [context]: The build context used for navigation.
  ///
  /// Returns:
  ///   - None.
  void launchSDK(BuildContext context) async {
    String accessToken = kycAccessToken;

    /// Retrieves a new KYC access token after a delay of 2 seconds.
    ///
    /// This function returns a `Future<String>` that resolves to a new KYC access token.
    /// It does this by delaying the execution of the `getKYCAccessToken` function with a
    /// duration of 2 seconds. The `getKYCAccessToken` function is called with the current
    /// `BuildContext` as an argument.
    ///
    /// Returns:
    ///   - A `Future<String>` that resolves to a new KYC access token.
    onTokenExpiration() async {
      return Future<String>.delayed(
          const Duration(seconds: 2), () => getKYCAccessToken(context));
    }

    final builder = SNSMobileSDK.init(accessToken, onTokenExpiration);

    snsMobileSDK =
        builder.withLocale(const Locale("en")).withDebug(true).build();

    final result = await snsMobileSDK!.launch();
    if (result.success == true) {
      var token = await StorageHelper.getValue(StorageKeys.token);
      if (context.mounted) {
        await getUserInfo(token, context);
      }
    }
    log("Completed with result: $result");
  }

  /// This function is called after the user successfully signs in.
  /// It is used to fetch the user's information from the API.
  ///
  /// The function takes one parameter: `token`, which is the token obtained from the
  /// sign in API.
  ///
  /// The function first calls the `getUserInfoApiCall` function from the Repository
  /// class to fetch the user's information. The response from the API is then
  /// parsed and the state is updated accordingly.
  ///
  /// If the user's email address verification status is "pending", the user is
  /// navigated to the `EmailVerification` widget with the email address.
  ///
  /// If the user's identity verification status is "open", the user is navigated to
  /// the `VerifyIdentity` widget.
  ///
  /// If neither of the above conditions are met, the user is navigated back to
  /// the previous two screens.
  ///
  /// [token]: The token obtained from the sign in API.
  /// [context]: The context of the widget.
  Future<void> getUserInfo(String token, BuildContext context) async {
    try {
      http.Response response =
          await Repository().getUserInfoApiCall(token, context);
      var jsonResponse = jsonDecode(response.body);
      UserInfoModel userInfoModel = UserInfoModel.fromJson(jsonResponse);
      if (userInfoModel.status?.details?.emailAddressVerificationStatus ==
          "pending") {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmailVerification(
                email: '${userInfoModel.emailAddress}',
              ),
            ),
          );
        }
      } else if (userInfoModel.status?.details?.amld5VerificationStatus !=
          "verified") {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OriginQuestions(),
            ),
          );
          // Navigator.pop(context);
        }
      } else {
        isLoading = false;
        var list = await StorageHelper.getValue(StorageKeys.myAddressesList);
        final List<dynamic> jsonList = jsonDecode(list);
        final List<Map<String, dynamic>> data =
            jsonList.map((item) => item as Map<String, dynamic>).toList();
        var xApiKey = await StorageHelper.getValue(StorageKeys.xApiKey);
        var isSandBox = await StorageHelper.getValue(StorageKeys.isSandBox);
        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BTCDirect(
                  myAddressesList: data,
                  xApiKey: xApiKey,
                  isSandBox: isSandBox,
                ),
              ));
        }
      }
      setState(() {});
    } catch (e) {
      isLoading = false;
      setState(() {});
      log(e.toString());
    }
  }

  /// Displays a bottom sheet with a message indicating that no ID is available.
  bottomSheet(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CommonColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return CommonFontDimen(
          child: SizedBox(
            height: h * 0.32,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: CommonColors.black,
                        size: 26,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.01),
                const Center(
                  child: Text(
                    "No ID available",
                    style: TextStyle(
                      color: CommonColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(right: w * 0.08, left: w * 0.08, top: 10),
                  child: const Center(
                    child: Text(
                      "No worries. You can verify your ID later. You will receive a reminder via email if you didn't verify within a day.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CommonColors.greyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        fontFamily: 'TextaAlt',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.only(right: h * 0.03, left: h * 0.03),
                  child: CommonButtonItem.filled(
                    text: "Close",
                    fontSize: 20,
                    textStyle: const TextStyle(
                      fontSize: 24,
                      color: CommonColors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'TextaAlt',
                    ),
                    bgColor: CommonColors.blueColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
