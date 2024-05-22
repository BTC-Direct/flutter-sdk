import 'dart:developer';

import 'package:btc_direct/src/features/onboarding/ui/signin.dart';
import 'package:btc_direct/src/presentation/config_packages.dart';
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
  TextEditingController searchTextController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Nationality> combinedItemsList = [];
  List<Nationality> mostCommonItemsList = [];
  int countrySelectIndex = -1;

  @override

  /// Initializes the state of the widget.
  ///
  /// This function is called when the widget is inserted into the tree. It performs the following actions:
  /// - Calls the `getCountries` function with the `context` parameter to retrieve the list of countries.
  ///
  /// This function does not have any parameters.
  /// This function does not return any value.
  void initState() {
    super.initState();
    getCountries(context);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
      appBarTitle: isEmailAlready ? "" : "Create account",
      isAppBarLeadShow: isEmailAlready ? false : true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Form(
            key: formKey,
            child: isLoading
                ? SizedBox(
                    height: h,
                    child: const Center(child: CircularProgressIndicator()))
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
                                    color: isPersonalButton
                                        ? CommonColors.backgroundColor
                                        : CommonColors.transparent,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Personal',
                                      style: TextStyle(
                                        color: isPersonalButton
                                            ? CommonColors.blueColor
                                            : CommonColors.greyColor,
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
                                    color: isBusinessButton
                                        ? CommonColors.backgroundColor
                                        : CommonColors.transparent,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Business',
                                      style: TextStyle(
                                        color: isBusinessButton
                                            ? CommonColors.blueColor
                                            : CommonColors.greyColor,
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

  /// Returns a widget that displays an error message if the email is already in use.
  ///
  emailAlreadyView() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Column(children: [
      Image.asset(Images.mailAlreadyUsed, height: h * 0.2, width: w * 0.4),
      SizedBox(
        height: h * 0.02,
      ),
      Text(
        "${emailController.text} is already in use",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: CommonColors.black,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontFamily: 'TextaAlt',
        ),
      ),
      SizedBox(
        height: h * 0.03,
      ),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            children: [
              const TextSpan(
                  text:
                      "There is already an account registered with this email address. If you've started or completed a previous registration, "),
              TextSpan(
                text: "log in",
                style: const TextStyle(
                  color: CommonColors.blueColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'TextaAlt',
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    isEmailAlready = false;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignIn()));
                  },
              ),
              const TextSpan(text: " to continue."),
            ],
            style: const TextStyle(
              color: CommonColors.greyColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'TextaAlt',
            )),
      ),
      SizedBox(
        height: h * 0.2,
      ),
      CommonButtonItem.filled(
        text: "Back to previous page",
        fontSize: 20,
        textStyle: const TextStyle(
          fontSize: 24,
          color: CommonColors.white,
          fontWeight: FontWeight.w600,
          fontFamily: 'TextaAlt',
        ),
        bgColor: CommonColors.blueColor,
        onPressed: () {
          isEmailAlready = false;
          passwordController.clear();
          setState(() {});
        },
      ),
    ]);
  }

  /// Returns a widget that displays the business bottom sheet.
  businessBottomSheet(BuildContext context) {
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
          child: Stack(
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
                          color: CommonColors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'TextaAlt',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: w * 0.08, left: w * 0.08, top: 20),
                      child: const Center(
                        child: Text(
                          "Invest in cryptocurrency with your\ncompany. Before we continue please be\naware of the following requirements.",
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
                    Padding(
                      padding: EdgeInsets.only(
                          right: w * 0.05, left: w * 0.05, top: 20),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: CommonColors.greyColor,
                            size: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "We only accept Dutch and Belgium companies.",
                              style: TextStyle(
                                color: CommonColors.greyColor,
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
                      padding: EdgeInsets.only(
                          right: w * 0.05, left: w * 0.05, top: 20),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.contact_mail,
                            color: CommonColors.greyColor,
                            size: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "You must be the majority shareholder of your company.",
                              style: TextStyle(
                                color: CommonColors.greyColor,
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
                      padding: EdgeInsets.only(
                          right: w * 0.05, left: w * 0.05, top: 20),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: CommonColors.greyColor,
                            size: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "After signing up we need to verify your information. Once we're done we send you an email with information on how to complete your business account.",
                              style: TextStyle(
                                color: CommonColors.greyColor,
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
                      color: CommonColors.black,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
          CommonButtonItem.outline(
            text: "BTC Direct for business",
            icon: const Icon(
              Icons.info_outline,
              color: CommonColors.blueColor,
              size: 20,
            ),
            textStyle: const TextStyle(
              fontSize: 20,
              color: CommonColors.blueColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'TextaAlt',
            ),
            width: w * 0.9,
            bgColor: CommonColors.blueColor,
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
                      color: CommonColors.black,
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
                      color: CommonColors.black,
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
            color: CommonColors.black,
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
            color: CommonColors.black,
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
          suffix: const Icon(Icons.keyboard_arrow_down_outlined,
              color: CommonColors.greyColor),
          onTap: () {
            nationalitySelectBottomSheet(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Choose your nationality.';
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
                color: CommonColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'TextaAlt',
              ),
            ),
            Spacer(),
            Text(
              "Minimum of 8 characters",
              style: TextStyle(
                color: CommonColors.greyColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
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
          validator: (p1) {
            if (p1 == null || p1.isEmpty) {
              return "This field is required";
            } else {
              if (p1.length < 8) {
                return "Minimum of 8 characters";
              } else if (p1.length > 64) {
                return 'Maximum of 64 characters';
              } else {
                return null;
              }
            }
            // FieldValidator.validatePassword(p1, text: "This field is required", validText: "Please enter valid password");
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
              side: const BorderSide(color: CommonColors.greyColor, width: 1.5),
              activeColor: CommonColors.blueColor,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                    children: [
                      const TextSpan(text: "I agree to the "),
                      TextSpan(
                        text: "terms and conditions",
                        style: const TextStyle(
                          color: CommonColors.blueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'TextaAlt',
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            http.Response response =
                                await Repository().getClientInfoApiCall();
                            if (response.statusCode == 200) {
                              var tempData = jsonDecode(response.body)['slug'];
                              final Uri url = Uri.parse(
                                  "https://btcdirect.eu/en-eu/terms-of-service?client=$tempData");
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            }
                          },
                      ),
                      const TextSpan(text: " and "),
                      TextSpan(
                        text: "privacy policy",
                        style: const TextStyle(
                          color: CommonColors.blueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'TextaAlt',
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            http.Response response =
                                await Repository().getClientInfoApiCall();
                            if (response.statusCode == 200) {
                              var tempData = jsonDecode(response.body)['slug'];
                              final Uri url = Uri.parse(
                                  "https://my-sandbox.btcdirect.eu/en-gb/privacy-policy?client=$tempData");
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            }
                          },
                      ),
                      const TextSpan(text: "."),
                    ],
                    style: const TextStyle(
                      color: CommonColors.black,
                      fontSize: 16,
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
                color: CommonColors.redColor,
                fontSize: 14,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: isCheckBoxValue2,
              onChanged: (value) {
                isCheckBoxValue2 = value!;
                setState(() {});
              },
              side: const BorderSide(color: CommonColors.greyColor, width: 1.5),
              activeColor: CommonColors.blueColor,
            ),
            const Expanded(
              child: Text(
                "Yes, I would like to regularly receive the newsletter by email and be informed about offers and promotions.",
                style: TextStyle(
                  color: CommonColors.black,
                  fontSize: 16,
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
        CommonButtonItem.filled(
          text: "Create account",
          fontSize: 20,
          textStyle: const TextStyle(
            fontSize: 24,
            color: CommonColors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'TextaAlt',
          ),
          bgColor: CommonColors.blueColor,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if (showError = !isChecked) {
                setState(() {});
              } else {
                createAccountApiCall(
                    context: context,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    nationalityCode:
                        '${combinedItemsList[countrySelectIndex].code}',
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

  /// Fetches the countries from the API and updates the state accordingly.
  /// This function calls the `getSystemInfoApiCall` function from the Repository class
  /// and decodes the response body into a list of `Nationality`.
  /// It then iterates over the list and adds the countries to the `combinedItemsList`.
  /// Finally, it adds one extra item to the `combinedItemsList` with name "Other nationality"
  /// and sets the state to update the nationality dropdown list.
  /// This function is called when the widget is mounted.
  /// [context]: The context of the widget.
  Future<void> getCountries(BuildContext context) async {
    List<Nationality> countryList = [];
    try {
      isLoading = true;
      http.Response response = await Repository().getSystemInfoApiCall();
      if (response.statusCode == 200) {
        var a = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${a["nationalities"]}");
        countryList = List<Nationality>.from(
            a["nationalities"].map((x) => Nationality.fromJson(x)));
        combinedItemsList = List.from(countryList)
          ..addAll(List.generate(
              1,
              (index) => Nationality(
                  name: "Other nationality",
                  code: "",
                  idSelfieRequired: true)));
        //combinedItemsList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        isLoading = false;
        setState(() {});
      } else if (response.statusCode >= 400) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
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
    } catch (e) {
      isLoading = false;
      setState(() {});
    }
  }

  /// This function shows a bottom sheet to select nationality.
  /// If the widget is mounted, it checks if the `combinedItemsList` is not empty.
  /// If it is not empty, it searches for "Belgium" and "Netherlands" in the list
  /// and swaps their positions. If the list is empty, it calls the `getCountries`
  /// function to fetch the list of nationalities.
  /// The function then shows a bottom sheet with the list of nationalities.
  /// The function takes one parameter which is the context of the widget.
  /// [context]: The context of the widget.
  nationalitySelectBottomSheet(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    List<Nationality> searchList = [];
    if (combinedItemsList.isNotEmpty) {
      searchList = List.from(combinedItemsList);
      int i = searchList.indexWhere((element) => element.name == "Belgium");
      Nationality tempB = Nationality(
          name: searchList[i].name,
          code: searchList[i].code,
          idSelfieRequired: searchList[i].idSelfieRequired);
      int j = searchList.indexWhere((element) => element.name == "Netherlands");
      Nationality tempN = Nationality(
          name: searchList[j].name,
          code: searchList[j].code,
          idSelfieRequired: searchList[j].idSelfieRequired);
      searchList.removeAt(i);
      searchList.insert(i, tempN);
      searchList.removeAt(j);
      searchList.insert(j, tempB);
    } else {
      getCountries(context);
      setState(() {});
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: CommonColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return CommonFontDimen(
            child: SizedBox(
              height: h,
              child: isLoading
                  ? SizedBox(
                      height: h,
                      child: const Center(child: CircularProgressIndicator()))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: h * 0.04),
                        Row(
                          children: [
                            SizedBox(width: w / 2.8),
                            const Text(
                              "Nationality",
                              style: TextStyle(
                                color: CommonColors.black,
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
                                    searchTextController.clear();
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
                          ],
                        ),
                        SizedBox(height: h * 0.01),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: searchTextController,
                            cursorColor: CommonColors.black,
                            style: const TextStyle(
                              color: CommonColors.black,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 8),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: CommonColors.black,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: CommonColors.blueColor, width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.5),
                              ),
                            ),
                            onChanged: (value) {
                              if (searchList.isNotEmpty) {
                                if (value.isNotEmpty) {
                                  List<Nationality> tempSearchList = searchList
                                      .where((nationalityName) =>
                                          nationalityName.name!
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
                                      .toList();
                                  setState(() {
                                    searchList = tempSearchList;
                                  });
                                } else {
                                  setState(() {
                                    searchList = combinedItemsList;
                                  });
                                }
                              } else {
                                setState(() {
                                  searchList = combinedItemsList;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(height: h * 0.02),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: w * 0.08),
                                  child: const Text(
                                    "Most common",
                                    style: TextStyle(
                                        color: CommonColors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'TextaAlt'),
                                  ),
                                ),
                                searchList.isEmpty
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: h * 0.25,
                                        child: ListView.builder(
                                          itemCount: searchList.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            if (searchList[index].name ==
                                                    "Netherlands" ||
                                                searchList[index].name ==
                                                    "Belgium" ||
                                                searchList[index].name ==
                                                    "Spain") {
                                              return Container(
                                                width: w,
                                                height: h * 0.08,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: w * 0.08),
                                                decoration: BoxDecoration(
                                                  color: countrySelectIndex ==
                                                          index
                                                      ? CommonColors
                                                          .backgroundColor
                                                          .withOpacity(0.4)
                                                      : CommonColors
                                                          .transparent,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      countrySelectIndex =
                                                          index;
                                                      nationalityController
                                                              .text =
                                                          '${searchList[index].name}';
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: w * 0.05,
                                                      ),
                                                      SvgPicture.network(
                                                        'https://widgets-sandbox.btcdirect.eu/img/flags/${(searchList[index].code)?.toLowerCase()}.svg',
                                                        width: 25,
                                                        height: 25,
                                                      ),
                                                      SizedBox(
                                                        width: w * 0.04,
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          '${searchList[index].name}',
                                                          style:
                                                              const TextStyle(
                                                            color: CommonColors
                                                                .black,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'TextaAlt',
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Icon(
                                                        countrySelectIndex ==
                                                                index
                                                            ? Icons.check
                                                            : null,
                                                        color:
                                                            CommonColors.black,
                                                        size: 15,
                                                      ),
                                                      SizedBox(
                                                        width: w * 0.02,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: w * 0.08, top: 8),
                                  child: const Text(
                                    "All",
                                    style: TextStyle(
                                        color: CommonColors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'TextaAlt'),
                                  ),
                                ),
                                searchList.isEmpty
                                    ? Container(
                                        width: w,
                                        height: h * 0.08,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: w * 0.08,
                                        ),
                                        decoration: BoxDecoration(
                                          color: countrySelectIndex == 0
                                              ? CommonColors.backgroundColor
                                                  .withOpacity(0.4)
                                              : CommonColors.transparent,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              Navigator.pop(context);
                                              otherNationalityBottomSheet(
                                                  context);
                                            });
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                width: w * 0.05,
                                              ),
                                              Container(
                                                height: 30,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                  color: CommonColors
                                                      .backgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                              ),
                                              SizedBox(
                                                width: w * 0.04,
                                              ),
                                              const Center(
                                                child: Text(
                                                  'Other nationality',
                                                  style: TextStyle(
                                                    color: CommonColors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'TextaAlt',
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              const Icon(
                                                Icons.info_sharp,
                                                color: CommonColors.greyColor,
                                                size: 22,
                                              ),
                                              SizedBox(
                                                width: w * 0.02,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: h * 3.1,
                                        child: ListView.builder(
                                          itemCount: searchList.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            if (searchList[index].name ==
                                                    "Netherlands" ||
                                                searchList[index].name ==
                                                    "Belgium" ||
                                                searchList[index].name ==
                                                    "Spain") {
                                              return Container();
                                            } else {
                                              return Container(
                                                width: w,
                                                height: h * 0.08,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: w * 0.08,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: countrySelectIndex ==
                                                          index
                                                      ? CommonColors
                                                          .backgroundColor
                                                          .withOpacity(0.4)
                                                      : CommonColors
                                                          .transparent,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      countrySelectIndex =
                                                          index;
                                                      nationalityController
                                                              .text =
                                                          '${searchList[index].name}';
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: w * 0.05,
                                                      ),
                                                      searchList[index].code ==
                                                              ""
                                                          ? Container(
                                                              height: 30,
                                                              width: 35,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: CommonColors
                                                                    .backgroundColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                            )
                                                          : SvgPicture.network(
                                                              'https://widgets-sandbox.btcdirect.eu/img/flags/${(searchList[index].code)?.toLowerCase()}.svg',
                                                              width: 25,
                                                              height: 25,
                                                            ),
                                                      SizedBox(
                                                        width: w * 0.04,
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          '${searchList[index].name}',
                                                          style:
                                                              const TextStyle(
                                                            color: CommonColors
                                                                .black,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'TextaAlt',
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Icon(
                                                        countrySelectIndex ==
                                                                index
                                                            ? Icons.check
                                                            : null,
                                                        color:
                                                            CommonColors.black,
                                                        size: 15,
                                                      ),
                                                      if (searchList[index]
                                                              .code ==
                                                          "")
                                                        Icon(
                                                          countrySelectIndex ==
                                                                  index
                                                              ? null
                                                              : Icons
                                                                  .info_sharp,
                                                          color: CommonColors
                                                              .greyColor,
                                                          size: 22,
                                                        ),
                                                      SizedBox(
                                                        width: w * 0.02,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: h * 0.01),
                      ],
                    ),
            ),
          );
        });
      },
    ).then((value) {
      if (nationalityController.text.isNotEmpty) {
        if (searchList[countrySelectIndex].code == "") {
          otherNationalityBottomSheet(context);
        }
      }
    });
  }

  //other nationality
  otherNationalityBottomSheet(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: CommonColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (BuildContext context) {
          return CommonFontDimen(
            child: SizedBox(
              height: h * 0.70,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.08, vertical: h * 0.008),
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
                            color: CommonColors.black,
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
                              color: CommonColors.black,
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
                          color: CommonColors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'TextaAlt',
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    Center(
                        child: SvgPicture.asset(Images.otherNationality,
                            colorFilter: const ColorFilter.mode(
                                CommonColors.greenColor, BlendMode.srcIn),
                            height: 50)),
                    const Text(
                      "Unfortunately we do not offer our service in your region.",
                      style: TextStyle(
                        color: CommonColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'TextaAlt',
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    const Text(
                      "We check your nationality during the ID verification. Choosing a different nationality will result the revoke of the application.",
                      style: TextStyle(
                        color: CommonColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'TextaAlt',
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    const Text(
                      "Regions where BTC Direct operates:\nAndorra, Austria, Belgium, Bulgaria, Croatia, Cyprus, Czechia, Denmark, Estonia, Finland, France, Germany, Gibraltar, Greece, Guernsey, Hungary, Iceland, Ireland, Isle of Man, Italy, Jersey, Latvia, Liechtenstein, Lithuania, Luxembourg, Malta, Monaco, Netherlands, Norway, Poland, Portugal, Romania, San Marino, Slovakia, Slovenia, Spain, Sweden, Switzerland, United Kingdom, Vatican City",
                      style: TextStyle(
                        color: CommonColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'TextaAlt',
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            ),
          );
        });
  }

  //create account
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
        log("Response: ${tempData.toString()}");
        var user = UserModel.fromJson(tempData);
        await StorageHelper.setValue(StorageKeys.token, '');
        log("Response::: ${user.toString()}");
        await StorageHelper.setValue(StorageKeys.identifier, identifier);
        if (context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmailVerification(
                    email: user.email.toString(), identifier: identifier),
              ));
        }
      } else if (response.statusCode >= 400) {
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (tempData['errors'].keys.toList()[j] == "ER002") {
              setState(() {
                isEmailAlready = true;
              });
            } else {
              if (errorCodeList[i].code ==
                  tempData['errors'].keys.toList()[j]) {
                if (context.mounted) {
                  AppCommonFunction().failureSnackBar(
                      context: context, message: '${errorCodeList[i].message}');
                }
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
