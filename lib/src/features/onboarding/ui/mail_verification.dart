import 'dart:developer';

import 'package:btcdirect/src/presentation/config_packages.dart';
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
            child: isLoading ? const Center(child: CircularProgressIndicator()) : Column(
              children: [
                SizedBox(
                  height: h * 0.025,
                ),
                Image.asset(
                  'assets/images/email.png',
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
                    color: AppColors.black,
                    fontFamily: 'TextaAlt',
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
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyColor,
                    fontFamily: 'TextaAlt',
                  ),
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                Pinput(
                  controller: pinputController,
                  length: 6,
                  errorText: "Invalid code",
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Invalid code';
                    }
                    return null;
                  },
                  onSubmitted: (value) {
                    debugPrint('onSubmitted: $value');
                    FocusScope.of(context).focusedChild?.unfocus();
                    setState(() {});
                  },
                  onCompleted: (value) {
                    debugPrint('onCompleted: $value');
                    FocusScope.of(context).focusedChild?.unfocus();
                    setState(() {});
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
                                  color: AppColors.blueColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'TextaAlt',
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (widget.identifier != null) {
                                      identifierReSendEmailApiCall(context, widget.email);
                                    }else{
                                      tokenReSendEmailApiCall(context, widget.email);
                                    }
                                  },
                              ),
                        const TextSpan(text: "."),
                      ],
                      style: const TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'TextaAlt',
                      )),
                )
                    : Text(reSendText,style: const TextStyle(
                  color: AppColors.greyColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'TextaAlt',
                )),
                SizedBox(
                  height: h * 0.16,
                ),
                ButtonItem.filled(
                  text: "Continue",
                  fontSize: 20,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'TextaAlt',
                  ),
                  bgColor: AppColors.blueColor,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (widget.identifier != null) {
                        identifierVerifyEmailApiCall(context, pinputController.text);
                      }else{
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

  identifierVerifyEmailApiCall(BuildContext context, String emailCode) async {
    try {
      isLoading = true;
      http.Response response = await Repository().identifierGetVerificationCodeApiCall(
        emailCode,
        widget.identifier ?? '',
      );
      if (response.statusCode == 202) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("verifyEmail Response ::: ${tempData.toString()}");
        var user = UserModel.fromJson(tempData);
        log("verifyEmail Response ${user.toString()}");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VerifyIdentity(),
            ));
      } else if (response.statusCode >= 400) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        //print("errorCodeList: $errorCodeList");
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
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

  identifierReSendEmailApiCall(BuildContext context, String email) async {
    try {
      isLoading = true;
      http.Response response = await Repository().identifierDetReSendEmailApiCall(
        email,
        widget.identifier ?? "",
      );
      if (response.statusCode == 202) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        isLoading = false;
        AppCommonFunction().successSnackBar(context: context, message: 'Verification code sent successfully');
      } else if (response.statusCode >= 400) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        //print("errorCodeList: $errorCodeList");
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
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

  tokenVerifyEmailApiCall(BuildContext context, String emailCode) async {
    try {
      isLoading = true;
      http.Response response = await Repository().tokenGetVerificationCodeApiCall(
        emailCode
      );
      if (response.statusCode == 202) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("verifyEmail Response ::: ${tempData.toString()}");
        var user = UserModel.fromJson(tempData);
        log("verifyEmail Response ${user.toString()}");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VerifyIdentity(),
            ));
      }
      else if (response.statusCode >= 400) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        //print("errorCodeList: $errorCodeList");
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
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

  tokenReSendEmailApiCall(BuildContext context, String email) async {
    try {
      isLoading = true;
      http.Response response = await Repository().tokenDetReSendEmailApiCall(
        email
      );
      if (response.statusCode == 202) {
        // var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        isLoading = false;
        reSendText = 'Email sent';
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
              AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
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
