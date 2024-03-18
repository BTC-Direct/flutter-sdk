import 'dart:developer';
import 'package:btcdirect/src/core/model/userinfomodel.dart';
import 'package:btcdirect/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
                ? SizedBox(height: h / 1.3, child: const Center(child: CircularProgressIndicator()))
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: h * 0.02,
                ),
                const Center(
                    child: Text(
                  "Welcome",
                  style: TextStyle(color: AppColors.black, fontSize: 24, fontFamily: 'TextaAlt', fontWeight: FontWeight.w700),
                )),
                SizedBox(
                  height: h * 0.04,
                ),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          const TextSpan(text: "please enter your details. Don't have\nan account? "),
                          TextSpan(
                            text: "Create new account",
                            style: const TextStyle(
                              color: AppColors.blueColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'TextaAlt',
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OnBoarding(),
                                  ),
                                );
                              },
                          ),
                          const TextSpan(text: "."),
                        ],
                        style: const TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'TextaAlt',
                        )),
                  ),
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.only(top: h * 0.015, bottom: h * 0.01),
                  child: const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      fontFamily: 'TextaAlt',
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
                  padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.01),
                  child: const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                ),
                CommonTextFormField(
                  textEditingController: passwordController,
                  validator: (p1) {
                        //FieldValidator.validatePassword(p1, text: "This field is required", validText: "Please enter valid password");
                        if(p1 == null || p1.isEmpty) {
                          return  "This field is required";
                        }else{
                          if(p1.length < 8) {
                            return "Minimum of 8 characters";
                          }else if(p1.length > 64){
                            return 'Maximum of 64 characters';
                          }else{
                            return null;
                          }
                        }
                  },
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
                          isPasswordShow ? Icons.visibility_off : Icons.visibility,
                        )),
                  ),
                ),
                InkWell(
                  onTap: () async {
                      http.Response response = await Repository().getClientInfoApiCall();
                      if(response.statusCode == 200){
                        var tempData = jsonDecode(response.body)['slug'];
                        final Uri url = Uri.parse("https://my-sandbox.btcdirect.eu/en-gb/forgot-password?client=$tempData");
                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: h * 0.002, bottom: h * 0.01),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blueColor,
                        fontFamily: 'TextaAlt',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.22,
                ),
                ButtonItem.filled(
                  text: "Sign in",
                  fontSize: 20,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'TextaAlt',
                  ),
                  bgColor: AppColors.blueColor,
                  onPressed: () {
                    if(formKey.currentState!.validate()) {
                    signInAccountApiCall(context: context, email: emailController.text, password: passwordController.text);
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

  signInAccountApiCall({
    required BuildContext context,
    String email = '',
    String password = '',
  }) async {
    try {
      isLoading = true;
      http.Response response = await Repository().signInAccountApiCall(email, password,context);
      if (response.statusCode == 200) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        await StorageHelper.setValue(StorageKeys.token, tempData['token']);
        await StorageHelper.setValue(StorageKeys.userId, tempData['uuid']);
        await StorageHelper.setValue(StorageKeys.refreshToken, tempData['refreshToken']);
        getUserInfo(tempData['token']);
      }
      isLoading = false;
      setState(() {});
    } catch (e) {
      log(e.toString());
      isLoading = false;
      setState(() {});
    }
  }

  getUserInfo(String token) async {
    try {
      var response = await Repository().getUserInfoApiCall(token,context);
      UserInfoModel userInfoModel = UserInfoModel.fromJson(response);
      if (userInfoModel.status?.details?.emailAddressVerificationStatus == "pending") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerification(
              email: '${userInfoModel.emailAddress}',
            ),
          ),
        );
        emailController.clear();
        passwordController.clear();
      } else if (userInfoModel.status?.details?.identityVerificationStatus == "open")  {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VerifyIdentity(),
          ),
        );
        emailController.clear();
        passwordController.clear();
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
      setState(() {});
    } catch (e) {
      setState(() {});
      log(e.toString());
    }
  }
}
