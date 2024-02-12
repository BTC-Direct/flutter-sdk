import 'dart:developer';

import 'package:btcdirect/src/core/model/userinfomodel.dart';
import 'package:btcdirect/src/features/buy/ui/paymentmethod.dart';
import 'package:btcdirect/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  int indexValue = 0;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController coinAmount = TextEditingController();
  TextEditingController walletAddress = TextEditingController();
  TextEditingController paymentMethod = TextEditingController();
  int coinSelectIndex = 0;
  int walletSelectIndex = 0;
  int paymentSelectIndex = 0;
  late Timer timer;
  int start = 10;
  double price = 0.0;
  bool isLoading = false;
  bool isTimerShow = false;
  bool showAllFees = false;
  bool isAmountValid = false;
  bool isUserVerified = false;
  List<CoinModel> coinList = [];
  List<PaymentMethods> payMethodList = [];
  UserInfoModel userInfoModel = UserInfoModel();
  String paymentFees = "0.00";
  List myWalletList = [
    {
      "name": "My wallet",
      "walletAddress": "0xe6A21cCa767544a610F9227391d91637cffeF688",
      "icon": "https://widgets-sandbox.btcdirect.eu/img/currencies/USDT.svg",
    },
    {
      "name": "My wallet 2",
      "walletAddress": "0xe6A21cCa767544a610F9227391d91637cffeF688",
      "icon": "https://widgets-sandbox.btcdirect.eu/img/currencies/USDC.svg",
    },
  ];

  @override
  void initState() {
    super.initState();
    getCoinDataList();
    walletAddress = TextEditingController(text: "My wallet");
    paymentMethod = TextEditingController(text: "Bancontact");
    startTimer();
    isTimerShow = true;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
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
                topContainerView(),
                SizedBox(
                  height: h * 0.04,
                ),
                isLoading ? const Center(child: CircularProgressIndicator()) : orderView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  topContainerView() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              "Order",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: indexValue == 0 ? AppColors.blueColor : AppColors.greyColor.withOpacity(0.6),
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
                color: AppColors.blueColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Payment",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: indexValue == 1 ? AppColors.blueColor : AppColors.greyColor.withOpacity(0.6),
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
                color: indexValue == 1 ? AppColors.blueColor : AppColors.greyColor.withOpacity(0.6),
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
                color: indexValue == 2 ? AppColors.blueColor : AppColors.greyColor.withOpacity(0.6),
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
                color: indexValue == 2 ? AppColors.blueColor : AppColors.greyColor.withOpacity(0.6),
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
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.015),
            child: RichText(
              text: TextSpan(
                  children: [
                    const TextSpan(text: "Your order must be at least €30.00. "),
                    TextSpan(
                      text: "Click here ",
                      style: const TextStyle(
                        color: AppColors.blueColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'TextaAlt',
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
                    color: AppColors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'TextaAlt',
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
              color: AppColors.black,
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
              if (enteredValue >= 30) {
                isAmountValid = false;
                onAmountChanged(value: p0, isPay: true);
                var token = await StorageHelper.getValue(StorageKeys.token);
                print("getToken: $token");
                if (token != null && token != "") {
                  getUserInfo(token);
                }
              } else {
                isAmountValid = true;
              }
            }
          },
          suffix: Container(
            width: 100,
            margin: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: AppColors.backgroundColor,
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
                  decoration: const BoxDecoration(color: AppColors.darkBlueColor, shape: BoxShape.circle),
                  child: const Text(
                    "€",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
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
              color: AppColors.black,
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
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: InkWell(
              onTap: () {
                coinSelectBottomSheet(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    coinSelectIndex == 0 ? '${coinList.first.coinIcon}' : '${coinList[coinSelectIndex].coinIcon}',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    coinSelectIndex == 0 ? "${coinList.first.coinTicker}" : "${coinList[coinSelectIndex].coinTicker}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.black,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Amount is required';
            }
            return null;
          },
          onEditingComplete: () {
            // startTimer();
            // isTimerShow = true;
            // setState(() {});
          },
        ),
        SizedBox(
          height: h * 0.01,
        ),
        Row(
          children: [
            if (isTimerShow && start > 0)
              Icon(
                Icons.watch_later_outlined,
                color: AppColors.greyColor,
                size: h * 0.022,
              )
            else
              SizedBox(height: h * 0.015, width: h * 0.015, child: const CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.greyColor)),
            if (isTimerShow)
              Text(
                " Refresh in ${start}s",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.greyColor,
                  fontFamily: 'TextaAlt',
                ),
              ),
            const Spacer(),
            Text(
              "${coinList[coinSelectIndex].coinTicker} €$price",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.greyColor,
                fontFamily: 'TextaAlt',
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.01),
          child: const Text(
            "Your wallet address",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        CommonTextFormField(
          textEditingController: walletAddress,
          readOnly: true,
          prefix: SizedBox(
            width: 60,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.01),
              child: SvgPicture.network(
                '${coinList[coinSelectIndex].coinIcon}',
                width: 25,
                height: 25,
              ),
            ),
          ),
          suffix: const Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.greyColor),
          onTap: () {
            //print("wallet icon ::: ${coinList[coinSelectIndex].coinIcon}");
            myWalletAddressBottomSheet(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Chooes your wallet address.';
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
              color: AppColors.black,
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
              padding: EdgeInsets.symmetric(horizontal: w * 0.02),
              child: paymentSelectIndex == 0
                  ? SvgPicture.network(
                      paymentSelectIndex == 0
                          ? "https://widgets-sandbox.btcdirect.eu/img/payment-methods/bancontact.svg"
                          : 'https://widgets-sandbox.btcdirect.eu/img/payment-methods/${payMethodList[paymentSelectIndex].code}.svg',
                      width: 30,
                      height: 30,
                      fit: BoxFit.fitWidth,
                    )
                  : const SizedBox(),
            ),
          ),
          suffix: const Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.greyColor),
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
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  fontFamily: 'TextaAlt',
                ),
              ),
              const Spacer(),
              Text(
                "€${amount.text}.00",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
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
                  color: AppColors.blueColor,
                  fontFamily: 'TextaAlt',
                  decoration: TextDecoration.underline,
                ),
              ),
              Icon(
                showAllFees ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: AppColors.blueColor,
                size: 20,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: showAllFees ? 120.0 : 0.0,
            width: w,
            color: AppColors.backgroundColor.withOpacity(0.4),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const Center(
                          child: Text(
                            'Payment method',
                            style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.info_sharp,
                          color: AppColors.greyColor,
                          size: 20,
                        ),
                        const Spacer(),
                        Text(
                          "€$paymentFees",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyColor,
                            fontFamily: 'TextaAlt',
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Text(
                            'Network fee',
                            style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.info_sharp,
                          color: AppColors.greyColor,
                          size: 20,
                        ),
                        Spacer(),
                        Text(
                          "€0.00",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyColor,
                            fontFamily: 'TextaAlt',
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Center(
                          child: Text(
                            'Total fee',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                        ),
                        Text(
                          "€$paymentFees",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
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
                color: AppColors.errorBackgroundColor,
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
                    color: AppColors.redColor,
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
                                color: AppColors.blueColor,
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
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const VerifyIdentity(),
                                      ),
                                    );
                                  }
                                },
                            ),
                            const TextSpan(text: "."),
                          ],
                          style: const TextStyle(
                            color: AppColors.black,
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
        ButtonItem.filled(
          text: "Continue",
          isEnabled: isUserVerified ? false : true,
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
                      walletAddress: myWalletList[walletSelectIndex]['walletAddress'].toString(),
                      coinTicker: coinList[coinSelectIndex].coinTicker.toString(),
                      paymentFees: paymentFees,
                    ),
                  ),
                ).then((value) {
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
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
              Expanded(
                child: ListView.builder(
                  itemCount: coinList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: w,
                      height: h * 0.08,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.008),
                      decoration: BoxDecoration(
                        color: coinSelectIndex == index ? AppColors.backgroundColor : AppColors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            coinSelectIndex = index;
                            start = 10;
                          });
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
                                      color: AppColors.black,
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
                                      color: AppColors.black,
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
                              color: AppColors.black,
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
        );
      },
    );
  }

  paymentMethodBottomSheet(BuildContext context) {
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
              Expanded(
                child: ListView.builder(
                  itemCount: payMethodList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: w,
                      height: h * 0.08,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.004),
                      decoration: BoxDecoration(
                        color: paymentSelectIndex == index ? AppColors.backgroundColor : AppColors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            paymentSelectIndex = index;
                            paymentMethod.text = '${payMethodList[index].label}';
                            Navigator.pop(context);
                          });
                        },
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
                              fit: BoxFit.fitWidth,
                            ),
                            SizedBox(
                              width: w * 0.04,
                            ),
                            Center(
                              child: Text(
                                '${payMethodList[index].label}',
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
                              paymentSelectIndex == index ? Icons.check : null,
                              color: AppColors.black,
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
        );
      },
    );
  }

  myWalletAddressBottomSheet(BuildContext context) {
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
        return SizedBox(
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
              Expanded(
                child: ListView.builder(
                  itemCount: myWalletList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: w,
                      height: h * 0.08,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.008),
                      decoration: BoxDecoration(
                        color: walletSelectIndex == index ? AppColors.backgroundColor : AppColors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: InkWell(
                        onTap: () {
                          walletAddress.text = myWalletList[index]['name'];
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
                              '${myWalletList[index]['icon']}',
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
                                    '${myWalletList[index]['name']}',
                                    style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'TextaAlt',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      AppCommonFunction().truncateStringWithEllipsis(myWalletList[index]['walletAddress'],10,5) ,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.black,
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
                              walletSelectIndex == index ? Icons.check : Icons.arrow_forward_ios_sharp,
                              color: AppColors.black,
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
        );
      },
    );
  }

  ///API CALL FUNCTION

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          // timer.cancel();
          getCurrencyPrice();
          onAmountChanged(value: amount.text, isPay: true);
          start = 10;
          setState(() {});
        } else {
          start--;
          setState(() {});
        }
      },
    );
  }

  getCoinDataList() async {
    try {
      isLoading = true;
      List<GetPairsModel> currencyPairs = [];
      var response = await Repository().getCoinDataListApiCall();
      currencyPairs = List<GetPairsModel>.from(response.map((x) => GetPairsModel.fromJson(x)));
      for (var i = 0; i < currencyPairs.length; i++) {
        coinList.add(CoinModel(
            coinName: currencyPairs[i].currencyPair!.split("-")[0],
            coinTicker: currencyPairs[i].currencyPair!.split("-")[0],
            coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/${currencyPairs[i].currencyPair!.split("-")[0]}.svg"));
        setState(() {});
      }
      getPaymentMethod();
    } catch (e) {
      isLoading = false;
      setState(() {});
      log(e.toString());
    }
  }

  getPaymentMethod() async {
    try {
      isLoading = true;
      PaymentMethodModel payMethodPairs;
      var response = await Repository().getPaymentMethodApiCall();
      payMethodPairs = PaymentMethodModel.fromJson(response);
      for (var i = 0; i < payMethodPairs.paymentMethods!.length; i++) {
        payMethodList.add(
          PaymentMethods(
            code: payMethodPairs.paymentMethods![i].code,
            fee: payMethodPairs.paymentMethods![i].fee,
            limit: payMethodPairs.paymentMethods![i].limit,
            label: payMethodPairs.paymentMethods![i].label,
          ),
        );
      }
      paymentMethod.text = '${payMethodList.first.label}';
      isLoading = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      setState(() {});
      log(e.toString());
    }
  }

  getCurrencyPrice() async {
    var response = await Repository().getPriceApiCall();
    setState(() {
      price = double.parse(response["buy"]["${coinList[coinSelectIndex].coinTicker}-EUR"].toString());
    });
  }

  onAmountChanged({required String value, required bool isPay}) async {
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
      if(response.statusCode == 200){
        if (!isPay) {
          setState(() {
            amount.text = tempData["fiatAmount"].toString() != "null" ? tempData["fiatAmount"].toString() : "0.00";
            paymentFees = tempData["paymentMethodCost"].toString() != "null" ? tempData["paymentMethodCost"].toString() : "0.00";
          });
        } else {
          setState(() {
            coinAmount.text = tempData["cryptoAmount"].toString() != "null" ? tempData["cryptoAmount"].toString() : "0.00";
            paymentFees = tempData["paymentMethodCost"].toString() != "null" ? tempData["paymentMethodCost"].toString() : "0.00";
          });
        }
      }
      else if(response.statusCode == 400){
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              // AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
              log(errorCodeList[i].message);
              print('ErrorMessage ::: ${errorCodeList[i].message}');
            }
          }
        }
      }
    }
  }

  getUserInfo(String token) async {
    try {
      var response = await Repository().getUserInfoApiCall(token);
      print("Response :: ${response.toString()}");
      userInfoModel = UserInfoModel.fromJson(response);
      print("userInfoModel Response :: ${userInfoModel.toString()}");
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

class CoinModel {
  String? coinName;
  String? coinTicker;
  String? coinIcon;

  CoinModel({
    this.coinName,
    this.coinTicker,
    this.coinIcon,
  });
}
