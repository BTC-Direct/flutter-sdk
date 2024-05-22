import 'dart:developer';

import 'package:btc_direct/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;

class EmailVerification extends StatefulWidget {
  final String email;
  final String? identifier;

  const EmailVerification({super.key, required this.email, this.identifier});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final smartAuth = SmartAuth();
  bool isLoading = false;
  String reSendText = "";
  final pinputController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pinputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
      isAppBarLeadShow: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: h * 0.025,
                ),
                Image.asset(
                  Images.emailIcon,
                  height: h * 0.25,
                  width: w * 0.5,
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                const Text(
                  'Email verification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: CommonColors.black,
                    fontFamily: 'TextaAlt',
                    package: "btc_direct",
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Text(
                  'Enter the 6-digit code you received on your email ${widget.email}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: CommonColors.greyColor,
                    fontFamily: 'TextaAlt',
                    package: "btc_direct",
                  ),
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                Pinput(
                  controller: pinputController,
                  length: 6,
                  errorText: "Invalid code",
                  focusNode: FocusNode(),
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Invalid code';
                    }
                    return null;
                  },
                  onSubmitted: (value) {
                    debugPrint('onSubmitted: $value');
                    FocusScope.of(context);
                  },
                  onCompleted: (value) {
                    debugPrint('onCompleted: $value');
                    FocusScope.of(context);
                  },
                ),
                SizedBox(
                  height: h * 0.01,
                ),
                reSendText.isEmpty
                    ? RichText(
                        text: TextSpan(
                            children: [
                              const TextSpan(text: "Didn't receive a code?  "),
                              TextSpan(
                                text: "Resend",
                                style: const TextStyle(
                                  color: CommonColors.blueColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'TextaAlt',
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (widget.identifier != null) {
                                      identifierReSendEmailApiCall(
                                          context, widget.email);
                                    } else {
                                      tokenReSendEmailApiCall(
                                          context, widget.email);
                                    }
                                  },
                              ),
                              const TextSpan(text: "."),
                            ],
                            style: const TextStyle(
                              color: CommonColors.greyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'TextaAlt',
                            )),
                      )
                    : Text(reSendText,
                        style: const TextStyle(
                          color: CommonColors.greyColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'TextaAlt',
                        )),
                SizedBox(
                  height: h * 0.16,
                ),
                CommonButtonItem.filled(
                  text: "Continue",
                  fontSize: 20,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    color: CommonColors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'TextaAlt',
                    package: "btc_direct",
                  ),
                  bgColor: CommonColors.blueColor,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (widget.identifier != null) {
                        identifierVerifyEmailApiCall(
                            context, pinputController.text);
                      } else {
                        tokenVerifyEmailApiCall(context, pinputController.text);
                      }
                    }
                  },
                ),
                SizedBox(
                  height: h * 0.10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// This function verifies the email code sent to the user's email.
  /// It calls the `identifierGetVerificationCodeApiCall` function from the Repository class
  /// and decodes the response body into a `UserModel`.
  /// If the response is 202, it navigates to the Verify Identity screen.
  /// If the response is not 202, it checks the error codes and shows the appropriate error message using the `failureSnackBar` function from the AppCommonFunction class.
  /// Finally, it sets the `isLoading` value to false.
  ///
  /// [context]: The context of the widget.
  /// [emailCode]: The email verification code entered by the user.
  void identifierVerifyEmailApiCall(
      BuildContext context, String emailCode) async {
    try {
      isLoading = true;
      http.Response response =
          await Repository().identifierGetVerificationCodeApiCall(
        emailCode,
        widget.identifier ?? '',
      );
      if (response.statusCode == 202) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("verifyEmail Response ::: ${tempData.toString()}");
        var user = UserModel.fromJson(tempData);
        log("verifyEmail Response ${user.toString()}");
        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const VerifyIdentity(),
              ));
        }
      } else if (response.statusCode >= 400) {
        var errorCodeList = await AppCommonFunction().getJsonData();
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
            }
          }
        }
      }
      isLoading = false;
      setState(() {});
    } catch (e) {
      log(e.toString());
      isLoading = false;
      setState(() {});
    }
  }

  /// This function re-sends the email verification code to the user.
  ///
  /// It calls the `identifierDetReSendEmailApiCall` function from the Repository class
  /// and passes the email address and the identifier to the API.
  ///
  /// If the response is 202, it sets the `reSendText` state to 'Email sent.'
  /// and displays the message for 2 seconds before setting it back to an empty string.
  ///
  /// If the response is not 202, it checks the error codes and shows the appropriate
  /// error message using the `failureSnackBar` function from the AppCommonFunction class.
  ///
  /// The function is called when the user clicks the "Resend email" button.
  ///
  /// [context]: The context of the widget.
  /// [email]: The email address of the user.
  void identifierReSendEmailApiCall(BuildContext context, String email) async {
    try {
      isLoading = true;
      http.Response response =
          await Repository().identifierDetReSendEmailApiCall(
        email,
        widget.identifier ?? "",
      );
      if (response.statusCode == 202) {
        isLoading = false;
        reSendText = 'Email sent.';
        setState(() {});
        Future.delayed(const Duration(seconds: 2), () {
          reSendText = '';
          setState(() {});
        });
      } else if (response.statusCode >= 400) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        //print("errorCodeList: $errorCodeList");
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
            }
          }
        }
      }
      isLoading = false;
      setState(() {});
    } catch (e) {
      log(e.toString());
      isLoading = false;
      setState(() {});
    }
  }

  /// Verifies the email code sent to the user's email.
  ///
  /// This function calls the `tokenGetVerificationCodeApiCall` function from the Repository class
  /// and decodes the response body into a `UserModel`.
  /// If the response is 202, it navigates to the Verify Identity screen.
  /// If the response is not 202, it checks the error codes and shows the appropriate error message using the `failureSnackBar` function from the AppCommonFunction class.
  ///
  /// Parameters:
  /// - `context`: The context of the widget.
  /// - `emailCode`: The email verification code entered by the user.

  tokenVerifyEmailApiCall(BuildContext context, String emailCode) async {
    try {
      isLoading = true;
      http.Response response =
          await Repository().tokenGetVerificationCodeApiCall(emailCode);
      if (response.statusCode == 202) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("verifyEmail Response ::: ${tempData.toString()}");
        var user = UserModel.fromJson(tempData);
        log("verifyEmail Response ${user.toString()}");
        if (context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VerifyIdentity(),
              ));
        }
      } else if (response.statusCode >= 400) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        //print("errorCodeList: $errorCodeList");
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
            }
          }
        }
      }
      isLoading = false;
      setState(() {});
    } catch (e) {
      log(e.toString());
      isLoading = false;
      setState(() {});
    }
  }

  /// This function re-sends the email verification code to the user.
  ///
  /// It calls the `tokenDetReSendEmailApiCall` function from the Repository class
  /// and passes the email address to the API.
  ///
  /// If the response is 202, it sets the `reSendText` state to 'Email sent.'
  /// and displays the message for 2 seconds before setting it back to an empty string.
  ///
  /// If the response is not 202, it checks the error codes and shows the appropriate
  /// error message using the `failureSnackBar` function from the AppCommonFunction class.
  ///
  /// The function is called when the user clicks the "Resend email" button.
  ///
  /// [context]: The context of the widget.
  /// [email]: The email address of the user.
  tokenReSendEmailApiCall(BuildContext context, String email) async {
    try {
      isLoading = true;
      http.Response response =
          await Repository().tokenDetReSendEmailApiCall(email);
      if (response.statusCode == 202) {
        // var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        isLoading = false;
        reSendText = 'Email sent.';
        setState(() {});
        Future.delayed(const Duration(seconds: 2), () {
          reSendText = '';
          setState(() {});
        });
        //AppCommonFunction().successSnackBar(context: context, message: 'Verification code sent successfully');
      } else if (response.statusCode >= 400) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        //print("errorCodeList: $errorCodeList");
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
            }
          }
        }
      }
      isLoading = false;
      setState(() {});
    } catch (e) {
      log(e.toString());
      isLoading = false;
      setState(() {});
    }
  }
}
