import 'dart:developer';
import 'package:btc_direct/src/core/model/userinfo_model.dart';
import 'package:btc_direct/src/features/buy/ui/paymentmethod.dart';
import 'package:btc_direct/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//ignore: must_be_immutable
class BTCDirect extends StatefulWidget {
  String xApiKey;
  List<Map<String, dynamic>> myAddressesList;
  bool isSandBox;

  BTCDirect({super.key, required this.myAddressesList, required this.xApiKey, required this.isSandBox});

  @override
  State<BTCDirect> createState() => _BTCDirectState();
}

class _BTCDirectState extends State<BTCDirect> {
  int indexValue = 0;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController coinAmount = TextEditingController();
  TextEditingController walletAddress = TextEditingController();
  TextEditingController paymentMethod = TextEditingController();
  int coinSelectIndex = 0;
  int paymentSelectIndex = 0;
  late Timer timer;
  int start = 10;
  double price = 0.0;
  bool isLoading = false;
  bool isTimerShow = false;
  bool showAllFees = false;
  bool isAmountValid = false;
  bool isAmountMaximumValid = false;
  bool isUserVerified = false;
  bool isBankTransferButtonEnabled = false;
  List<CoinModel> coinList = [];
  List<PaymentMethods> payMethodList = [];
  UserInfoModel userInfoModel = UserInfoModel();
  String paymentFees = "0.00";
  String networkFees = "0.00";
  num totalFees = 0.00;
  String? paymentMethodCode;

  @override
  void initState() {
    initData().then((value) {
      getAllData();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  /// Initializes the data for the application.
  /// This function ensures that the Flutter binding is initialized, sets the preferred
  /// orientations to portrait up and portrait down, initializes the storage helper,
  /// and clears the addresses list.
  /// Returns a `Future` that completes when the initialization is complete.
  Future initData() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await StorageHelper.initialize();
    addressesList.clear();
  }


  /// Gets all the required data and initializes the state.
  /// Sets the xApiKey and isSandBox values from the widget.
  /// If the widget contains the addresses list, copies the addresses to the state.
  /// Enables the immersive mode for the app.
  /// Calls the getCoinDataList function to fetch the coin data.
  /// Initializes the wallet address and payment method text controllers.
  /// Starts the timer and enables or disables the bank transfer button based on the payment method.
  void getAllData() {
    xApiKey = widget.xApiKey;
    isSandBox = widget.isSandBox;
    if (widget.myAddressesList.isNotEmpty) {
      for (int i = 0; i < widget.myAddressesList.length; i++) {
        addressesList.add(WalletAddressModel(
          address: widget.myAddressesList[i]['address'],
          currency: widget.myAddressesList[i]['currency'],
          id: widget.myAddressesList[i]['id'],
          name: widget.myAddressesList[i]['name'],
        ));
      }
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    log("xApiKey *** $xApiKey *** ::: addressesList *** ${addressesList.length} *** ::: isSendBox *** $isSandBox");
    getCoinDataList(context);
    walletAddress = TextEditingController(text: "My wallet");
    paymentMethod = TextEditingController(text: "Bancontact");
    isTimerShow = true;
    startTimer();
    isBankTransferButtonEnabled = updateButtonState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return CommonFontDimen(
      child: FooterContainer(
        appBarTitle: "Checkout",
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: h * 0.01,
                  ),
                  topContainerView(context),
                  SizedBox(
                    height: h * 0.04,
                  ),
                  isLoading ? SizedBox(height: h / 1.6, child: const Center(child: CircularProgressIndicator())) : orderView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  topContainerView(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              "Order",
              maxLines: 1,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: indexValue == 0 ? CommonColors.blueColor : CommonColors.greyColor.withOpacity(0.6),
                fontFamily: 'TextaAlt',
              ),
            ),
            SizedBox(
              height: h * 0.008,
            ),
            Container(
              width: w / 3.5,
              height: h * 0.007,
              decoration: BoxDecoration(
                color: CommonColors.blueColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Payment",
              maxLines: 1,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: indexValue == 1 ? CommonColors.blueColor : CommonColors.greyColor.withOpacity(0.6),
                fontFamily: 'TextaAlt',
              ),
            ),
            SizedBox(
              height: h * 0.008,
            ),
            Container(
              width: w / 3.5,
              height: h * 0.007,
              decoration: BoxDecoration(
                color: indexValue == 1 ? CommonColors.blueColor : CommonColors.greyColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Complete",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: indexValue == 2 ? CommonColors.blueColor : CommonColors.greyColor.withOpacity(0.6),
                fontFamily: 'TextaAlt',
              ),
            ),
            SizedBox(
              height: h * 0.008,
            ),
            Container(
              width: w / 3.5,
              height: h * 0.007,
              decoration: BoxDecoration(
                color: indexValue == 2 ? CommonColors.blueColor : CommonColors.greyColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Order View Widget

  orderView() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: isAmountValid,
          child: Container(
            decoration: BoxDecoration(
              color: CommonColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.015),
            child: isAmountMaximumValid
                ? RichText(
                    text: TextSpan(
                        children: [
                          const TextSpan(text: "You can not currently order this amount using this currency."),
                          TextSpan(
                            text: "Click here ",
                            style: const TextStyle(
                              color: CommonColors.blueColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'TextaAlt',
                              package: "btc_direct",
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                amount.text = "2500";
                                onAmountChanged(value: "2500", isPay: true);
                                isAmountValid = false;
                              },
                          ),
                          const TextSpan(text: "to automatically fill in your maximum amount of €2500.00."),
                        ],
                        style: const TextStyle(
                          color: CommonColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'TextaAlt',
                          package: "btc_direct",
                        )),
                  )
                : RichText(
                    text: TextSpan(
                        children: [
                          const TextSpan(text: "Your order must be at least €30.00. "),
                          TextSpan(
                            text: "Click here ",
                            style: const TextStyle(
                              color: CommonColors.blueColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'TextaAlt',
                              package: "btc_direct",
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                amount.text = "30";
                                onAmountChanged(value: "30", isPay: true);
                                isAmountValid = false;
                              },
                          ),
                          const TextSpan(text: "to automatically fill in the minimum amount of €30.00."),
                        ],
                        style: const TextStyle(
                          color: CommonColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'TextaAlt',
                          package: "btc_direct",
                        )),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.01),
          child: const Text(
            "You pay",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CommonColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        CommonTextFormField(
          textEditingController: amount,
          keyBoardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: "min. €30.00",
          onChanged: (p0) async {
            if (p0.isNotEmpty || p0 != "") {
              final double enteredValue = double.parse(p0);
              if (enteredValue >= 30 && enteredValue <= 2500.00) {
                isAmountValid = false;
                onAmountChanged(value: p0, isPay: true);
                var token = await StorageHelper.getValue(StorageKeys.token);
                if (token != null && token != "") {
                  getUserInfo(token);
                }
              } else {
                isAmountValid = true;
                isAmountMaximumValid = false;
                if (enteredValue >= 2500.00) {
                  isAmountMaximumValid = true;
                }
              }
            }
          },
          suffix: Container(
            width: 100,
            margin: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: CommonColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(color: CommonColors.darkBlueColor, shape: BoxShape.circle),
                  child: const Text(
                    "€",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: CommonColors.white,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                const Text(
                  "EUR",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CommonColors.black,
                    fontFamily: 'TextaAlt',
                  ),
                ),
              ],
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Amount is required';
            } else if (double.parse(value) < 30) {
              return "The minimum amount is €30.00";
            } else if (double.parse(value) > 2500.00 && isAmountMaximumValid == true) {
              return "The maximum amount is €2500.00";
            } else {
              return null;
            }
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.01),
          child: const Text(
            "You get",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CommonColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        CommonTextFormField(
          textEditingController: coinAmount,
          keyBoardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (p0) {
            if (p0.isNotEmpty || p0 != "") {
              onAmountChanged(value: p0, isPay: false);
            } else {
              amount.clear();
            }
          },
          suffix: Container(
            width: 100,
            margin: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: CommonColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: InkWell(
              onTap: () {
                coinSelectBottomSheet(context);
              },
              child: coinList.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.network(
                          coinSelectIndex == 0 ? '${coinList.first.coinIcon}' : '${coinList[coinSelectIndex].coinIcon}',
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          coinSelectIndex == 0 ? "${coinList.first.coinTicker}" : "${coinList[coinSelectIndex].coinTicker}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: CommonColors.black,
                            fontFamily: 'TextaAlt',
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: CommonColors.black,
                          size: 20,
                        ),
                      ],
                    )
                  : Container(),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Amount is required';
            }
            return null;
          },
          onEditingComplete: () {},
        ),
        SizedBox(
          height: h * 0.01,
        ),
        Row(
          children: [
            if (isTimerShow && start > 0)
              Icon(
                Icons.watch_later_outlined,
                color: CommonColors.greyColor,
                size: h * 0.022,
              )
            else
              SizedBox(height: h * 0.015, width: h * 0.015, child: const CircularProgressIndicator(strokeWidth: 1.5, color: CommonColors.greyColor)),
            if (isTimerShow)
              Text(
                " Refresh in ${start}s",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CommonColors.greyColor,
                  fontFamily: 'TextaAlt',
                ),
              ),
            const Spacer(),
            coinList.isNotEmpty
                ? Text(
                    "${coinList[coinSelectIndex].coinTicker} €$price",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CommonColors.greyColor,
                      fontFamily: 'TextaAlt',
                    ),
                  )
                : Container(),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.01),
          child: const Text(
            "Your wallet address",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CommonColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        CommonTextFormField(
          textEditingController: walletAddress,
          readOnly: true,
          prefix: SizedBox(
            width: 60,
            child: coinList.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.01),
                    child: SvgPicture.network(
                      '${coinList[coinSelectIndex].coinIcon}',
                      width: 25,
                      height: 25,
                    ),
                  )
                : Container(),
          ),
          suffix: const Icon(Icons.keyboard_arrow_down_outlined, color: CommonColors.greyColor),
          onTap: () {
            myWalletAddressBottomSheet(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Choose your wallet address.';
            }
            return null;
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.015, bottom: h * 0.01),
          child: const Text(
            "Select payment method",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CommonColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        CommonTextFormField(
          textEditingController: paymentMethod,
          readOnly: true,
          prefix: SizedBox(
            width: 60,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.01),
              child: payMethodList.isNotEmpty
                  ? SvgPicture.network(
                      "https://widgets-sandbox.btcdirect.eu/img/payment-methods/$paymentMethodCode.svg",
                      width: 25,
                      height: 25,
                      fit: BoxFit.contain,
                    )
                  : const SizedBox(),
            ),
          ),
          suffix: const Icon(Icons.keyboard_arrow_down_outlined, color: CommonColors.greyColor),
          onTap: () {
            paymentMethodBottomSheet(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Select your payment method.';
            }
            return null;
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.04, bottom: h * 0.01),
          child: Row(
            children: [
              const Text(
                "Total amount:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: CommonColors.black,
                  fontFamily: 'TextaAlt',
                ),
              ),
              const Spacer(),
              Text(
                amount.text.isEmpty ? "0.00" : "€${double.parse(amount.text).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: CommonColors.black,
                  fontFamily: 'TextaAlt',
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              showAllFees = !showAllFees;
            });
          },
          child: Row(
            children: [
              const Spacer(),
              Text(
                showAllFees ? 'Hide Fees' : 'All Fees Included',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: CommonColors.blueColor,
                  fontFamily: 'TextaAlt',
                  decoration: TextDecoration.underline,
                ),
              ),
              Icon(
                showAllFees ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: CommonColors.blueColor,
                size: 20,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: showAllFees ? 125.0 : 0.0,
            width: w,
            color: CommonColors.backgroundColor.withOpacity(0.4),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Center(
                          child: Text(
                            'Payment method',
                            style: TextStyle(
                              color: CommonColors.greyColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            paymentMethodInfoBottomSheet(context);
                          },
                          icon: const Icon(
                            Icons.info_sharp,
                            size: 20,
                          ),
                          color: CommonColors.greyColor,
                        ),
                        const Spacer(),
                        Text(
                          "€$paymentFees",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: CommonColors.greyColor,
                            fontFamily: 'TextaAlt',
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Center(
                          child: Text(
                            'Network fee',
                            style: TextStyle(
                              color: CommonColors.greyColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            networkFeeInfoBottomSheet(context);
                          },
                          icon: const Icon(
                            Icons.info_sharp,
                            size: 20,
                          ),
                          color: CommonColors.greyColor,
                        ),
                        const Spacer(),
                        Text(
                          "€$networkFees",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: CommonColors.greyColor,
                            fontFamily: 'TextaAlt',
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Center(
                          child: Text(
                            'Total fee',
                            style: TextStyle(
                              color: CommonColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                        ),
                        Text(
                          "€${totalFees.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: CommonColors.black,
                            fontFamily: 'TextaAlt',
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
            visible: isUserVerified,
            child: Container(
              decoration: BoxDecoration(
                color: CommonColors.errorBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.02),
              height: h * 0.18,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outlined,
                    size: 20,
                    color: CommonColors.redColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          children: [
                            const TextSpan(text: "The order cannot be completed as your account registration hasn't been completed yet. "),
                            TextSpan(
                              text: "Click here to continue your registration",
                              style: const TextStyle(
                                color: CommonColors.blueColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'TextaAlt',
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  if (userInfoModel.status?.details?.emailAddressVerificationStatus == "pending") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EmailVerification(
                                          email: '${userInfoModel.emailAddress}',
                                        ),
                                      ),
                                    ).then((value) {
                                      startTimer();
                                      var token = StorageHelper.getValue(StorageKeys.token);
                                      if (token != null && token.isNotEmpty) {
                                        getUserInfo(token);
                                      }
                                    });
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const VerifyIdentity(),
                                      ),
                                    ).then((value) {
                                      startTimer();
                                      var token = StorageHelper.getValue(StorageKeys.token);
                                      if (token != null && token.isNotEmpty) {
                                        getUserInfo(token);
                                      }
                                    });
                                  }
                                },
                            ),
                            const TextSpan(text: "."),
                          ],
                          style: const TextStyle(
                            color: CommonColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'TextaAlt',
                          )),
                    ),
                  ),
                ],
              ),
            )),
        SizedBox(
          height: showAllFees ? 35.0 : h * 0.10,
        ),
        CommonButtonItem.filled(
          text: "Continue",
          isEnabled: isUserVerified ? false : true,
          fontSize: 20,
          textStyle: const TextStyle(
            fontSize: 22,
            color: CommonColors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'TextaAlt',
          ),
          bgColor: CommonColors.blueColor,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              timer.cancel();
              if (userInfoModel.status?.status == "pending") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerifyIdentity(),
                  ),
                ).then((value) {
                  startTimer();
                });
              } else if (userInfoModel.status?.status == "validated") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentMethod(
                              amount: amount.text,
                              paymentMethodCode: payMethodList[paymentSelectIndex].code.toString(),
                              paymentMethodName: payMethodList[paymentSelectIndex].label.toString(),
                              walletName: walletAddress.text,
                              walletAddress: addressesList[coinSelectIndex].address.toString(),
                              coinTicker: coinList[coinSelectIndex].coinTicker.toString(),
                              paymentFees: paymentFees,
                              networkFees: networkFees,
                            ))).then((value) {
                  startTimer();
                });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Landing(),
                  ),
                ).then((value) {
                  startTimer();
                  var token = StorageHelper.getValue(StorageKeys.token);
                  if (token != null && token.isNotEmpty) {
                    getUserInfo(token);
                  }
                });
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

  coinSelectBottomSheet(BuildContext context) {
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
            height: h * 0.70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(width: w / 2.5),
                    const Text(
                      "Currency",
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
                Expanded(
                  child: ListView.builder(
                    itemCount: coinList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: w,
                        height: h * 0.08,
                        margin: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.008),
                        decoration: BoxDecoration(
                          color: coinSelectIndex == index ? CommonColors.backgroundColor : CommonColors.transparent,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              coinSelectIndex = index;
                              start = 10;
                            });
                            walletAddress.text = addressesList[index].name;
                            onAmountChanged(value: amount.text, isPay: true);
                            getCurrencyPrice();
                            Navigator.pop(context);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: w * 0.05,
                              ),
                              SvgPicture.network(
                                '${coinList[index].coinIcon}',
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(
                                width: w * 0.02,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: h * 0.015),
                                  Center(
                                    child: Text(
                                      '${coinList[index].coinName}',
                                      style: const TextStyle(
                                        color: CommonColors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'TextaAlt',
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '${coinList[index].coinTicker}',
                                      style: const TextStyle(
                                        color: CommonColors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'TextaAlt',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Icon(
                                coinSelectIndex == index ? Icons.check : Icons.arrow_forward_ios_sharp,
                                color: CommonColors.black,
                                size: 15,
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
              ],
            ),
          ),
        );
      },
    );
  }

  paymentMethodBottomSheet(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    late PaymentMethods selectedItem;
    //updateButtonState();
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
          child: SafeArea(
            child: SizedBox(
              height: h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: h * 0.01),
                  Row(
                    children: [
                      SizedBox(width: w / 3.5),
                      const Text(
                        "Payment method",
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
                  SizedBox(height: h * 0.01),
                  Expanded(
                    child: ListView.builder(
                      itemCount: payMethodList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: w,
                          height: h * 0.08,
                          margin: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.004),
                          decoration: BoxDecoration(
                            color: index == 0 ? CommonColors.backgroundColor : CommonColors.transparent,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: InkWell(
                            onTap: (isBankTransferButtonEnabled || !(payMethodList[index].label == 'Bank Transfer'))
                                ? () {
                                    setState(() {
                                      // paymentSelectIndex = index;
                                      paymentMethod.text = '${payMethodList[index].label}';
                                      paymentMethodCode = '${payMethodList[index].code}';
                                      selectedItem = payMethodList[index];
                                      payMethodList.remove(selectedItem);
                                      payMethodList.insert(0, selectedItem);
                                      Navigator.pop(context);
                                      log(
                                        'images:- https://widgets-sandbox.btcdirect.eu/img/payment-methods/${payMethodList[paymentSelectIndex].code}.svg',
                                      );
                                    });
                                  }
                                : null,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: w * 0.04,
                                ),
                                SvgPicture.network(
                                  'https://widgets-sandbox.btcdirect.eu/img/payment-methods/${payMethodList[index].code}.svg',
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: w * 0.04,
                                ),
                                isBankTransferButtonEnabled
                                    ? Center(
                                        child: Text(
                                          '${payMethodList[index].label}',
                                          style: const TextStyle(
                                            color: CommonColors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'TextaAlt',
                                          ),
                                        ),
                                      )
                                    : payMethodList[index].label == 'Bank Transfer'
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Text(
                                                  '${payMethodList[index].label}',
                                                  style: const TextStyle(
                                                    color: CommonColors.greyColor,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'TextaAlt',
                                                  ),
                                                ),
                                              ),
                                              const Center(
                                                child: Text(
                                                  'Mon-Fri 09:00AM - 6:00PM',
                                                  style: TextStyle(
                                                    color: CommonColors.greyColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'TextaAlt',
                                                  ),
                                                ),
                                              ),
                                              const Center(
                                                child: Text(
                                                  'Mon-Fri 09:00AM - 18:00PM',
                                                  style: TextStyle(
                                                    color: CommonColors.greyColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'TextaAlt',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Center(
                                            child: Text(
                                              '${payMethodList[index].label}',
                                              style: const TextStyle(
                                                color: CommonColors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'TextaAlt',
                                              ),
                                            ),
                                          ),
                                const Spacer(),
                                Icon(
                                  index == 0 ? Icons.check : null,
                                  color: CommonColors.black,
                                  size: 15,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  paymentMethodInfoBottomSheet(BuildContext context) {
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
            height: h * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.01),
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
                const Center(
                  child: Text(
                    "Payment method",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CommonColors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                ),
                SizedBox(height: h * 0.01),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      "Payment method fees depend on the payment method selected. These fees are charged to us by the payment processor. Tip: Check carefully what is most advantageous for you and save on your purchase.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CommonColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'TextaAlt',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  networkFeeInfoBottomSheet(BuildContext context) {
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
            height: h * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.01),
                Align(
                  alignment: Alignment.centerRight,
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
                const Center(
                  child: Text(
                    "Network fee",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CommonColors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                ),
                SizedBox(height: h * 0.01),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      "The network fees serve as compensation for miners who verify and record transactions. They play a crucial role in network maintenance and ensure the security and speed of transactions.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CommonColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'TextaAlt',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  myWalletAddressBottomSheet(BuildContext context) {
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
            height: h * 0.70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(width: w / 2.5),
                    const Text(
                      "Your wallets",
                      style: TextStyle(
                        color: CommonColors.black,
                        fontSize: 20,
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
                            color: CommonColors.black,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.01),
                Expanded(
                  child: ListView.builder(
                    itemCount: addressesList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: w,
                        height: h * 0.08,
                        margin: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.008),
                        decoration: BoxDecoration(
                          color: coinSelectIndex == index ? CommonColors.backgroundColor : CommonColors.transparent,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: InkWell(
                          onTap: () {
                            coinSelectIndex = index;
                            walletAddress.text = addressesList[index].name;
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: w * 0.05,
                              ),
                              SvgPicture.network(
                                'https://widgets-sandbox.btcdirect.eu/img/currencies/${addressesList[index].currency}.svg',
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(
                                width: w * 0.02,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: h * 0.015),
                                  Center(
                                    child: Text(
                                      addressesList[index].name,
                                      style: const TextStyle(
                                        color: CommonColors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'TextaAlt',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        AppCommonFunction().truncateStringWithEllipsis(addressesList[index].address, 10, 5),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: CommonColors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'TextaAlt',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Icon(
                                coinSelectIndex == index ? Icons.check : Icons.arrow_forward_ios_sharp,
                                color: CommonColors.black,
                                size: 15,
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
              ],
            ),
          ),
        );
      },
    );
  }

    /// Updates the button state based on the current CET time.
    ///
    /// This function retrieves the current CET time using the `getCETDateTime` method from the `AppCommonFunction` class.
    /// It then formats the current time using the `DateFormat` class and prints it if the app is in debug mode.
    /// The function checks the current hour and minute of the CET time and returns a boolean value based on the following conditions:
    /// - If the current hour is between 9 and 17 (inclusive), it returns `true` indicating that it is within working hours.
    /// - If the current hour is 18 and the minute is 0, it returns `true` indicating that it includes 6:00 PM as working hours.
    /// - If the current hour is between 0 and 5 (inclusive), it returns `false` indicating that it is before 6:00 AM.
    /// - If the current hour is 6 and the minute is 0, it returns `false` indicating that it includes 6:00 AM as non-working hours.
    /// - Otherwise, it returns `false` indicating that it is after 6:00 PM.
    ///
    /// Returns a boolean value indicating the state of the button.
  bool updateButtonState() {
    DateTime currentCETTime = AppCommonFunction().getCETDateTime();
    var formattedDate = DateFormat('yyyy MM dd hh:mm:ss a').format(currentCETTime);
    if (kDebugMode) {
      print("formattedDate ::: $formattedDate");
    }
    int currentHour = currentCETTime.hour;
    int minute = currentCETTime.minute;
    if (currentHour >= 9 && currentHour < 18) {
      return true; // It's within working hours
    } else if (currentHour == 18 && minute == 0) {
      return true; // Include 6:00 PM as working hours
    } else if (currentHour >= 0 && currentHour < 6) {
      return false; // It's before 6:00 AM
    } else if (currentHour == 6 && minute == 0) {
      return false; // Include 6:00 AM as non-working hours
    } else {
      return false; // It's after 6:00 PM
    }
  }

  ///API CALL FUNCTION
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          getCurrencyPrice();
          if (amount.text.isNotEmpty) {
            onAmountChanged(value: amount.text, isPay: true);
          }
          start = 10;
          setState(() {});
        } else {
          start--;
          setState(() {});
        }
      },
    );
  }

  /// Fetches the coin data from the API and updates the state accordingly.
  /// This function calls the `getCoinDataListApiCall` function from the Repository class
  /// and decodes the response body into a list of `GetPairsModel`.
  /// It then iterates over the list and checks if the currency pair of each
  /// model matches with any of the currencies in the `addressesList`. If a match is
  /// found, it adds a `CoinModel` to the `coinList`.
  /// Finally, it calls the `getPaymentMethod` function to fetch the payment
  /// methods.
  /// This function is called when the widget is mounted.
  /// [context]: The context of the widget.
  Future<void> getCoinDataList(BuildContext context) async {
    try {
      isLoading = true;
      List<GetPairsModel> currencyPairs = [];
      http.Response response = await Repository().getCoinDataListApiCall();
      var tempData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        currencyPairs = List<GetPairsModel>.from(tempData.map((x) => GetPairsModel.fromJson(x)));
        for (int i = 0; i < currencyPairs.length; i++) {
          for (int j = 0; j < addressesList.length; j++) {
            if (currencyPairs[i].currencyPair!.split("-")[0] == addressesList[j].currency) {
              coinList.add(CoinModel(
                  coinName: currencyPairs[i].currencyPair!.split("-")[0],
                  coinTicker: currencyPairs[i].currencyPair!.split("-")[0],
                  coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/${currencyPairs[i].currencyPair!.split("-")[0]}.svg"));
            }
          }
        }
        if(context.mounted){
        getPaymentMethod(context);
        }
      } else if (response.statusCode >= 400) {
        setState(() {
          isLoading = false;
        });
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if(context.mounted){
                AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
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


  /// Fetches the payment methods from the API and updates the state accordingly.
  /// This function calls the `getPaymentMethodApiCall` function from the Repository class
  /// and decodes the response body into a `PaymentMethodModel`.
  /// It then iterates over the list of payment methods and adds each payment method
  /// to the `payMethodList`.
  /// Finally, it sets the `paymentMethod` text controller to the first payment method's label
  /// and the `paymentMethodCode` to the first payment method's code.
  /// This function is called when the widget is mounted.
  /// [context]: The context of the widget.
  Future<void> getPaymentMethod(BuildContext context) async {
    try {
      isLoading = true;
      PaymentMethodModel payMethodPairs;
      http.Response response = await Repository().getPaymentMethodApiCall();
      var tempData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        payMethodPairs = PaymentMethodModel.fromJson(tempData);
        for (var i = 0; i < payMethodPairs.paymentMethods!.length; i++) {
          payMethodList.add(
            PaymentMethods(
              code: payMethodPairs.paymentMethods![i].code,
              fee: payMethodPairs.paymentMethods![i].fee,
              label: payMethodPairs.paymentMethods![i].label,
              limit: payMethodPairs.paymentMethods![i].limit,
            ),
          );
        }
        paymentMethod.text = '${payMethodList.first.label}';
        paymentMethodCode = payMethodList.first.code;
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode >= 400) {
        setState(() {
          isLoading = false;
        });
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if(context.mounted) {
              AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
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

  /// Fetches the current price of the selected cryptocurrency currency from the API and
  /// updates the state accordingly.
  /// This function calls the `getPriceApiCall` function from the Repository class and
  /// decodes the response body into a price value.
  /// The function then parses the price value as a double and updates the `price` state.
  /// The function is called automatically when the user selects a different cryptocurrency
  /// currency from the dropdown list.
  void getCurrencyPrice() async {
    var response = await Repository().getPriceApiCall();
    setState(() {
      price = double.parse(response["buy"]["${coinList[coinSelectIndex].coinTicker}-EUR"].toString());
    });
  }

  /// This function is used to call the API for getting the amount related data such as
  /// fiat amount, payment method cost, and network fee cost.
  /// The API is called with the selected cryptocurrency currency, the amount of fiat or
  /// cryptocurrency currency, and the selected payment method.
  /// The response is then parsed and the state is updated accordingly.
  /// The function is used in the onAmountChanged callback of the text form field.
  /// If the amount is not empty or equals to "0.0", the API is called.
  /// If the API call is successful, the fiat amount, payment method cost,
  /// and network fee cost are updated in the state.
  /// If the API call is unsuccessful, the error messages are logged.
  /// The function takes two parameters: `value` which is the amount of fiat or
  /// cryptocurrency currency and `isPay` which is a boolean indicating whether it's a
  /// fiat or cryptocurrency currency.
  /// The function is synchronous.
  /// [value]: The amount of fiat or cryptocurrency currency.
  /// [isPay]: A boolean indicating whether it's a fiat or cryptocurrency currency.
  Future<void> onAmountChanged({required String value, required bool isPay}) async {
    Map<String, String> body = isPay
        ? {
            "currencyPair": "${coinList[coinSelectIndex].coinTicker}-EUR",
            "fiatAmount": value.toString(),
            "paymentMethod": "${payMethodList[paymentSelectIndex].code}",
          }
        : {
            "currencyPair": "${coinList[coinSelectIndex].coinTicker}-EUR",
            "cryptoAmount": value.toString(),
            "paymentMethod": "${payMethodList[paymentSelectIndex].code}",
          };
    if (value.isNotEmpty || value != "" || value != "0.0") {
      http.Response response = await Repository().getOnAmountChangedApiCall(body);
      var tempData = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (!isPay) {
          setState(() {
            amount.text = tempData["fiatAmount"].toString() != "null" ? tempData["fiatAmount"].toString() : "0.00";
            paymentFees = tempData["paymentMethodCost"].toString() != "null" ? tempData["paymentMethodCost"].toString() : "0.00";
            networkFees = tempData["networkFeeCost"].toString() != "null" ? tempData["networkFeeCost"].toString() : "0.00";
          });
        } else {
          setState(() {
            coinAmount.text = tempData["cryptoAmount"].toString() != "null" ? tempData["cryptoAmount"].toString() : "0.00";
            paymentFees = tempData["paymentMethodCost"].toString() != "null" ? tempData["paymentMethodCost"].toString() : "0.00";
            networkFees = tempData["networkFeeCost"].toString() != "null" ? tempData["networkFeeCost"].toString() : "0.00";
          });
        }
        totalFees = double.parse(paymentFees) + double.parse(networkFees);
      } else if (response.statusCode >= 400) {
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              // AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
              log(errorCodeList[i].message);
            }
          }
        }
      }
    }
  }

  /// Fetches the user info from the API and updates the state accordingly.
  /// This function calls the `getUserInfoApiCall` function from the Repository class
  /// and decodes the response body into a `UserInfoModel`.
  /// It then checks the status of the user info and sets the `isUserVerified` state
  /// to true if the status is "pending" and false otherwise.
  /// Finally, it calls the `setState` function to update the state.
  /// [token]: The token which is used to authenticate the API call.
  /// [context]: The context of the widget.
  Future<void> getUserInfo(String token) async {
    try {
      var response = await Repository().getUserInfoApiCall(token, context);
      userInfoModel = UserInfoModel.fromJson(response);
      if (userInfoModel.status?.status == "pending") {
        isUserVerified = true;
      } else {
        isUserVerified = false;
      }
      setState(() {});
    } catch (e) {
      setState(() {});
      log(e.toString());
    }
  }
}
