



import 'dart:developer';
import 'package:btcdirect/src/features/onboarding/ui/verify_identity.dart';
import 'package:http/http.dart' as http;
import 'package:btcdirect/src/presentation/config_packages.dart';

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
    return  FooterContainer(
      appBarTitle: "Sign in",
      isAppBarLeadShow: true,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06, ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.02,),
                const Center(child: Text("Welcome",style: TextStyle(color: AppColors.black, fontSize: 24, fontFamily: 'TextaAlt', fontWeight: FontWeight.w700),)),
                SizedBox(height: h * 0.04,),
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
                SizedBox(height: h * 0.03,),
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
                  validator: (p1) => FieldValidator.validatePassword(p1, text: "This field is required", validText: "Please enter valid password"),
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
                Padding(
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
                SizedBox(height: h * 0.22,),
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
                    signInAccountApiCall(context: context, email: emailController.text, password: passwordController.text);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const OnBoarding(),
                    //   ),
                    // );
                  },
                ),
                SizedBox(height: h * 0.12,),
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
      String identifier = AppCommonFunction().generateRandomString(36);
      print("identifier: $identifier");
      isLoading = true;
      http.Response response = await http.post(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/user/login"), body: {
        "emailAddress": email,
        "password": password,
      }, headers: {
        "X-Api-Key": xApiKey,
      });
      print('response StatusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyIdentity(),
            ));
      } else if (response.statusCode == 400) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
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
