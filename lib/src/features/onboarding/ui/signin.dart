import 'dart:developer';
import 'package:btc_direct/src/core/model/userinfo_model.dart';
import 'package:btc_direct/src/features/buy/ui/buy.dart';
import 'package:btc_direct/src/features/onboarding/ui/questions_answer/origin_questions.dart';
import 'package:btc_direct/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordShow = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
      appBarTitle: "Sign in",
      isAppBarLeadShow: true,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.06,
            ),
            child: isLoading
                ? SizedBox(
                    height: h / 1.3,
                    child: const Center(
                        child: CircularProgressIndicator(
                      color: CommonColors.blueColor,
                    )))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: h * 0.02,
                      ),
                      const Center(
                          child: Text(
                        "Welcome",
                        style: TextStyle(
                            color: CommonColors.black,
                            fontSize: 24,
                            fontFamily: 'TextaAlt',
                            package: "btc_direct",
                            fontWeight: FontWeight.w700),
                      )),
                      SizedBox(
                        height: h * 0.04,
                      ),
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              children: [
                                const TextSpan(
                                    text:
                                        "Please enter your details. Don't have\nan account? "),
                                TextSpan(
                                  text: "Create new account",
                                  style: const TextStyle(
                                    color: CommonColors.blueColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'TextaAlt',
                                    package: "btc_direct",
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const OnBoarding(),
                                        ),
                                      );
                                    },
                                ),
                                const TextSpan(text: "."),
                              ],
                              style: const TextStyle(
                                color: CommonColors.greyColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'TextaAlt',
                                package: "btc_direct",
                              )),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: h * 0.015, bottom: h * 0.01),
                        child: const Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: CommonColors.black,
                            fontFamily: 'TextaAlt',
                            package: "btc_direct",
                          ),
                        ),
                      ),
                      CommonTextFormField(
                        textEditingController: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: h * 0.02, bottom: h * 0.01),
                        child: const Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: CommonColors.black,
                            fontFamily: 'TextaAlt',
                            package: "btc_direct",
                          ),
                        ),
                      ),
                      CommonTextFormField(
                        textEditingController: passwordController,
                        validator: (p1) => FieldValidator.validatePassword(p1,
                            text: "This field is required",
                            validText: "Please enter valid password"),
                        obscure: isPasswordShow,
                        suffix: GestureDetector(
                          onTap: () {
                            if (isPasswordShow) {
                              isPasswordShow = false;
                              setState(() {});
                            } else {
                              isPasswordShow = true;
                              setState(() {});
                            }
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Icon(
                                isPasswordShow
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              )),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          http.Response response =
                              await Repository().getClientInfoApiCall();
                          if (response.statusCode == 200) {
                            var tempData = jsonDecode(response.body)['slug'];
                            final Uri url = Uri.parse(
                                "https://my-sandbox.btcdirect.eu/en-gb/forgot-password?client=$tempData");
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          }
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: h * 0.002, bottom: h * 0.01),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: CommonColors.blueColor,
                              fontFamily: 'TextaAlt',
                              package: "btc_direct",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.22,
                      ),
                      CommonButtonItem.filled(
                        text: "Sign in",
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
                            signInAccountApiCall(
                                context: context,
                                email: emailController.text,
                                password: passwordController.text);
                          }
                        },
                      ),
                      SizedBox(
                        height: h * 0.12,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Calls the API to sign in the user.
  ///
  /// This function calls the `signInAccountApiCall` function from the Repository class
  /// and passes the email address and the password to the API.
  ///
  /// If the response is 200, it stores the token, user id, and refresh token in the
  /// shared preferences and calls the `getUserInfo` function to fetch the user's information.
  ///
  /// If the response is not 200, it sets the `isLoading` value to false.
  ///
  /// [context]: The context of the widget.
  /// [email]: The email address of the user.
  /// [password]: The password of the user.
  Future<void> signInAccountApiCall({
    required BuildContext context,
    String email = '',
    String password = '',
  }) async {
    try {
      isLoading = true;
      http.Response response =
          await Repository().signInAccountApiCall(email, password, context);
      if (response.statusCode == 200) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        await StorageHelper.setValue(StorageKeys.token, tempData['token']);
        await StorageHelper.setValue(StorageKeys.userId, tempData['uuid']);
        await StorageHelper.setValue(
            StorageKeys.refreshToken, tempData['refreshToken']);
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          await getUserInfo(tempData['token'], context);
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
      });
    }
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
    setState(() {
      isLoading = true;
    });
    try {
      http.Response response =
          await Repository().getUserInfoApiCall(token, context);
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
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
        setState(() {
          isLoading = false;
        });
        emailController.clear();
        passwordController.clear();
      } else if (userInfoModel.status?.details?.identityVerificationStatus ==
          "open") {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VerifyIdentity(),
            ),
          );
        }
        setState(() {
          isLoading = false;
        });
        emailController.clear();
        passwordController.clear();
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
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
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
    } catch (e) {
      isLoading = false;
      setState(() {});
      log(e.toString());
    }
  }
}
