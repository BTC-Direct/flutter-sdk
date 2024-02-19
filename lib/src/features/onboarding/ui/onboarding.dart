import 'dart:developer';

import 'package:btcdirect/src/features/onboarding/ui/signin.dart';
import 'package:btcdirect/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  bool isLoading = false;
  bool isPersonalButton = true;
  bool isBusinessButton = false;
  bool isPasswordShow = true;
  bool isChecked = false;
  bool showError = false;
  bool isCheckBoxValue2 = false;
  bool isEmailAlready = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Nationality> countryList = [];
  List<Nationality> combinedItemsList = [];
  int countrySelectIndex = -1;

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
      appBarTitle: isEmailAlready ? "" :"Create account",
      isAppBarLeadShow: isEmailAlready ? false : true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Form(
            key: formKey,
            child: isLoading
                ? SizedBox(height: h, child: const Center(child: CircularProgressIndicator()))
                : isEmailAlready
                    ? emailAlreadyView()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  isBusinessButton = false;
                                  isPersonalButton = !isPersonalButton;
                                  setState(() {});
                                },
                                child: Container(
                                  height: h * 0.06,
                                  width: w * 0.38,
                                  decoration: BoxDecoration(
                                    color: isPersonalButton ? AppColors.backgroundColor : AppColors.transparent,
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Personal',
                                      style: TextStyle(
                                        color: isPersonalButton ? AppColors.blueColor : AppColors.greyColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'TextaAlt',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  isPersonalButton = false;
                                  isBusinessButton = !isPersonalButton;
                                  setState(() {});
                                },
                                child: Container(
                                  height: h * 0.06,
                                  width: w * 0.38,
                                  decoration: BoxDecoration(
                                    color: isBusinessButton ? AppColors.backgroundColor : AppColors.transparent,
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Business',
                                      style: TextStyle(
                                        color: isBusinessButton ? AppColors.blueColor : AppColors.greyColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'TextaAlt',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          personalInfoContainer(),
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  emailAlreadyView() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Column(children: [
      Image.asset('assets/images/email_in_use.png', height: h * 0.2, width: w * 0.4),
      SizedBox(height: h * 0.02,),
      const Text(
        "raininfo2@yopmail.com is already in use",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontFamily: 'TextaAlt',
        ),
      ),
      SizedBox(height: h * 0.03,),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            children: [
              const TextSpan(text: "There is already an account registered with this email address. If you've started or completed a previous registration, "),
              TextSpan(
                text: "log in",
                style: const TextStyle(
                  color: AppColors.blueColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'TextaAlt',
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                  isEmailAlready = false;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignIn()));
                  },
              ),
              const TextSpan(text: " to continue."),
            ],
            style: const TextStyle(
              color: AppColors.greyColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'TextaAlt',
            )),
      ),
      SizedBox(height: h * 0.2,),
      ButtonItem.filled(
        text: "Back to previous page",
        fontSize: 20,
        textStyle: const TextStyle(
          fontSize: 24,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontFamily: 'TextaAlt',
        ),
        bgColor: AppColors.blueColor,
        onPressed: () {
          isEmailAlready = false;
          passwordController.clear();
          setState(() {});
        },
      ),

    ]);
  }

  businessBottomSheet(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: w, height: h * 0.04),
                  const Center(
                    child: Text(
                      "BTC Direct for business",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'TextaAlt',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: w * 0.08, left: w * 0.08, top: 20),
                    child: const Center(
                      child: Text(
                        "Invest in cryptocurrency with your\ncompany. Before we continue please be\naware of the following requirements.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                          fontFamily: 'TextaAlt',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05, top: 20),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.greyColor,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            "We only accept Dutch and Belgium companies.",
                            style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05, top: 20),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.contact_mail,
                          color: AppColors.greyColor,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            "You must be the majority shareholder of your company.",
                            style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05, top: 20),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: AppColors.greyColor,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            "After signing up we need to verify your information. Once we're done we send you an email with information on how to complete your business account.",
                            style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: h * 0.03, left: h * 0.03),
                    child: ButtonItem.filled(
                      text: "Close",
                      fontSize: 20,
                      textStyle: const TextStyle(
                        fontSize: 24,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'TextaAlt',
                      ),
                      bgColor: AppColors.blueColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: h * 0.04,
                  ),
                ],
              ),
            ),
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
                    color: AppColors.black,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  personalInfoContainer() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isBusinessButton)
          SizedBox(
            height: h * 0.03,
          ),
        if (isBusinessButton)
          ButtonItem.outline(
            text: "BTC Direct for business",
            icon: const Icon(
              Icons.info_outline,
              color: AppColors.blueColor,
              size: 20,
            ),
            textStyle: const TextStyle(
              fontSize: 20,
              color: AppColors.blueColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'TextaAlt',
            ),
            width: w * 0.9,
            bgColor: AppColors.blueColor,
            onPressed: () {
              businessBottomSheet(context);
            },
          ),
        SizedBox(
          height: h * 0.03,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "First name",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                  SizedBox(
                    height: h * 0.012,
                  ),
                  CommonTextFormField(
                    textEditingController: firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: w * 0.06,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Last name",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                  SizedBox(
                    height: h * 0.012,
                  ),
                  CommonTextFormField(
                    textEditingController: lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: h * 0.03,
        ),
        const Text(
          "Email",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'TextaAlt',
          ),
        ),
        SizedBox(
          height: h * 0.012,
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
        SizedBox(
          height: h * 0.03,
        ),
        const Text(
          "Nationality",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'TextaAlt',
          ),
        ),
        SizedBox(
          height: h * 0.012,
        ),
        CommonTextFormField(
          textEditingController: nationalityController,
          readOnly: true,
          suffix: const Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.greyColor),
          onTap: () {
            nationalitySelectBottomSheet(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Chooes your nationality.';
            }
            return null;
          },
        ),
        SizedBox(
          height: h * 0.03,
        ),
        const Row(
          children: [
            Text(
              "Password",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'TextaAlt',
              ),
            ),
            Spacer(),
            Text(
              "Minimum of 8 characters",
              style: TextStyle(
                color: AppColors.greyColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'TextaAlt',
              ),
            ),
          ],
        ),
        SizedBox(
          height: h * 0.012,
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
        SizedBox(
          height: h * 0.03,
        ),
        Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (value) {
                isChecked = value!;
                showError = false;
                setState(() {});
              },
              side: const BorderSide(color: AppColors.greyColor, width: 1.5),
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (!states.contains(MaterialState.selected)) {
                  return AppColors.backgroundColor.withOpacity(0.4);
                }
                return null;
              }),
              activeColor: AppColors.blueColor,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                    children: [
                      const TextSpan(text: "I agree to the "),
                      TextSpan(
                        text: "terms and conditions",
                        style: const TextStyle(
                          color: AppColors.blueColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'TextaAlt',
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {},
                      ),
                      const TextSpan(text: " and "),
                      TextSpan(
                        text: "privacy policy",
                        style: const TextStyle(
                          color: AppColors.blueColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'TextaAlt',
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //launchUrlString('https://blockx. gitbook.io/blocx./get-started/masternode#vps-console-putty-or-terminal');
                          },
                      ),
                      const TextSpan(text: "."),
                    ],
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'TextaAlt',
                    )),
              ),
            ),
          ],
        ),
        Visibility(
          visible: showError && !isChecked,
          child: Padding(
            padding: EdgeInsets.only(left: w * 0.06),
            child: const Text(
              textAlign: TextAlign.center,
              "Please check the checkbox to continue.",
              style: TextStyle(
                color: AppColors.redColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'TextaAlt',
              ),
            ),
          ),
        ),
        SizedBox(
          height: h * 0.03,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: isCheckBoxValue2,
              onChanged: (value) {
                isCheckBoxValue2 = value!;
                setState(() {});
              },
              side: const BorderSide(color: AppColors.greyColor, width: 1.5),
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (!states.contains(MaterialState.selected)) {
                  return AppColors.backgroundColor.withOpacity(0.4);
                }
                return null;
              }),
              activeColor: AppColors.blueColor,
            ),
            SizedBox(
              width: w * 0.76,
              child: const Text(
                "Yes, I would like to regularly receive the newsletter by email and be informed about offers and promotions.",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'TextaAlt',
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: h * 0.03,
        ),
        ButtonItem.filled(
          text: "Create account",
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
              if (showError = !isChecked) {
                setState(() {});
              } else {
                createAccountApiCall(
                    context: context,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    nationalityCode: '${combinedItemsList[countrySelectIndex].code}',
                    email: emailController.text,
                    password: passwordController.text,
                    isBusiness: isBusinessButton,
                    newsletterSubscription: isCheckBoxValue2);
              }
            }
          },
        ),
        SizedBox(
          height: h * 0.12,
        ),
      ],
    );
  }

  getCountries() async {
    try {
      isLoading = true;
      http.Response response = await Repository().getSystemInfoApiCall();
      if (response.statusCode == 200) {
        var a = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${a["nationalities"]}");
        countryList = List<Nationality>.from(a["nationalities"].map((x) => Nationality.fromJson(x)));
        combinedItemsList = List.from(countryList)..addAll(List.generate(1, (index) => Nationality(name: "Other nationality", code: "", idSelfieRequired: true)));
        isLoading = false;
        setState(() {});
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
    } catch (e) {
      isLoading = false;
      print("getCountriesError :::: $e");
      setState(() {});
    }
  }

  nationalitySelectBottomSheet(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: h * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.01),
              Row(
                children: [
                  SizedBox(width: w / 2.8),
                  const Text(
                    "Nationality",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                  const Spacer(),
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
                          color: AppColors.black,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.01),
              Padding(
                padding: EdgeInsets.only(left: w * 0.08),
                child: const Text(
                  "All",
                  style: TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'TextaAlt'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: combinedItemsList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: w,
                      height: h * 0.08,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.008),
                      decoration: BoxDecoration(
                        color: countrySelectIndex == index ? AppColors.backgroundColor.withOpacity(0.4) : AppColors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            countrySelectIndex = index;
                            nationalityController.text = '${combinedItemsList[index].name}';
                            Navigator.pop(context);
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: w * 0.05,
                            ),
                            combinedItemsList[index].code == ""
                                ? Container(
                                    height: 30,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  )
                                : SvgPicture.network(
                                    'https://widgets-sandbox.btcdirect.eu/img/flags/${(combinedItemsList[index].code)?.toLowerCase()}.svg',
                                    width: 25,
                                    height: 25,
                                  ),
                            SizedBox(
                              width: w * 0.04,
                            ),
                            Center(
                              child: Text(
                                '${combinedItemsList[index].name}',
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'TextaAlt',
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              countrySelectIndex == index ? Icons.check : null,
                              color: AppColors.black,
                              size: 15,
                            ),
                            if (combinedItemsList[index].code == "")
                              Icon(
                                countrySelectIndex == index ? null : Icons.info_sharp,
                                color: AppColors.greyColor,
                                size: 22,
                              ),
                            SizedBox(
                              width: w * 0.02,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: h * 0.01),
            ],
          ),
        );
      },
    ).then((value) {
      if (combinedItemsList[countrySelectIndex].code == "") {
        otherNationalityBottomSheet(context);
      }
    });
  }

  otherNationalityBottomSheet(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: h * 0.70,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.008),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h * 0.01),
                  Row(
                    children: [
                      SizedBox(width: w / 4.5),
                      const Text(
                        "Other nationality",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'TextaAlt',
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            color: AppColors.black,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Center(
                    child: Text(
                      "We don't serve your region.",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'TextaAlt',
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  Center(child: SvgPicture.asset("assets/images/other_nationality.svg", color: AppColors.greenColor, height: 50)),
                  const Text(
                    "Unfortunately we do not offer our service in your region.",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  const Text(
                    "We check your nationality during the ID verification. Choosing a different nationality will result the revoke of the application.",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  const Text(
                    "Regions where BTC Direct operates:\nAndorra, Austria, Belgium, Bulgaria, Croatia, Cyprus, Czechia, Denmark, Estonia, Finland, France, Germany, Gibraltar, Greece, Guernsey, Hungary, Iceland, Ireland, Isle of Man, Italy, Jersey, Latvia, Liechtenstein, Lithuania, Luxembourg, Malta, Monaco, Netherlands, Norway, Poland, Portugal, Romania, San Marino, Slovakia, Slovenia, Spain, Sweden, Switzerland, United Kingdom, Vatican City",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                ],
              ),
            ),
          );
        });
  }

  createAccountApiCall({
    required BuildContext context,
    String firstName = '',
    String lastName = '',
    String email = '',
    String password = '',
    String nationalityCode = '',
    bool isBusiness = false,
    bool newsletterSubscription = false,
  }) async {
    try {
      String identifier = AppCommonFunction().generateRandomString(36);
      print("identifier: $identifier");
      setState(() {
        isLoading = true;
      });
      http.Response response = await Repository().createAccountApiCall(
        context,
        identifier,
        firstName,
        lastName,
        email,
        password,
        nationalityCode,
        isBusiness,
        newsletterSubscription,
      );
      if (response.statusCode == 201) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        var user = UserModel.fromJson(tempData);
        log("Response ${user.toString()}");
        await StorageHelper.setValue(StorageKeys.identifier, identifier);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmailVerification(email: user.email.toString(), identifier: identifier),
            ));
      } else if (response.statusCode == 400) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if(tempData['errors'].keys.toList()[j] == "ER002"){
              setState(() {
              isEmailAlready = true;
              });
            } else{
              if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
                AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
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
