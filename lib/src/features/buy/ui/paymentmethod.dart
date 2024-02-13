import 'dart:developer';

import 'package:btcdirect/src/core/model/order_model.dart';
import 'package:btcdirect/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentMethod extends StatefulWidget {
  String amount;
  String paymentMethodCode;
  String walletAddress;
  String walletName;
  String paymentMethodName;
  String coinTicker;
  String paymentFees;

  PaymentMethod(
      {super.key,
      required this.amount,
      required this.paymentMethodCode,
      required this.walletAddress,
      required this.walletName,
      required this.paymentMethodName,
      required this.coinTicker,
      required this.paymentFees
      });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  bool isTimerShow = false;
  bool showAllFees = false;
  bool isChecked = false;
  bool showError = false;
  bool isLoading = false;
  bool isOrderPending = false;
  bool isOrderButtonTapped = false;
  late Timer timer;
  late Timer paymentMethodTimer;
  int start = 10;
  int paymentMethodTimerStart = 10;
  String price = "0.0";

  @override
  void initState() {
    super.initState();
    onAmountChanged(value: widget.amount);
    startTimer();
    isTimerShow = true;
    if(isOrderButtonTapped){
      paymentMethodCompleteCheckTimer();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
      appBarTitle: "Checkout",
      isAppBarLeadShow: true,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            children: [
              SizedBox(
                height: h * 0.01,
              ),
              topContainerView(),
              SizedBox(
                height: h * 0.04,
              ),
              isLoading
                  ? SizedBox(height: h / 1.5, child: const Center(child: CircularProgressIndicator()))
                  : isOrderPending ? pendingStatusView() :paymentView(),
            ],
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
            const Text(
              "Order",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColors.blueColor,
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
            const Text(
              "Payment",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColors.blueColor,
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
              "Complete",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColors.greyColor.withOpacity(0.6),
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
                color: AppColors.greyColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Payment View Widget

  paymentView() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "You buy",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            fontFamily: 'TextaAlt',
          ),
        ),
        Row(
          children: [
            Text(
              "${widget.coinTicker} €$price",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontFamily: 'TextaAlt',
              ),
            ),
            const Spacer(),
            RichText(
              text: TextSpan(
                  children: [
                    const TextSpan(text: "Refresh in  "),
                    TextSpan(
                      text: "$start",
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'TextaAlt',
                      ),
                    ),
                    const TextSpan(text: "s"),
                  ],
                  style: const TextStyle(
                    color: AppColors.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'TextaAlt',
                  )),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.01),
          child: const Text(
            "Your wallet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        Text(
          '${widget.walletName} - ${AppCommonFunction().truncateStringWithEllipsis(widget.walletAddress, 10, 5)}',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
            fontFamily: 'TextaAlt',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.01),
          child: const Text(
            "Payment method",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        Row(
          children: [
            SvgPicture.network(
              'https://widgets-sandbox.btcdirect.eu/img/payment-methods/${widget.paymentMethodCode}.svg',
              width: 30,
              height: 30,
            ),
            SizedBox(
              width: w * 0.02,
            ),
            Text(
              widget.paymentMethodName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontFamily: 'TextaAlt',
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.01),
          child: const Text(
            "Fees",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontFamily: 'TextaAlt',
            ),
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
                child:  Column(
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
                          "€${widget.paymentFees}",
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
                          "€${widget.paymentFees}",
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
        Padding(
          padding: EdgeInsets.only(top: h * 0.04, bottom: h * 0.01),
          child: Row(
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  fontFamily: 'TextaAlt',
                ),
              ),
              const Spacer(),
              Text(
                "€${widget.amount}",
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
        SizedBox(
          height: h * 0.06,
        ),
        Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                  showError = false;
                });
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
                      const TextSpan(text: "I accept the "),
                      TextSpan(
                        text: "general terms and conditions",
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
          height: h * 0.02,
        ),
        ButtonItem.filled(
          text: "Continue order",
          fontSize: 20,
          textStyle: const TextStyle(
            fontSize: 22,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'TextaAlt',
          ),
          bgColor: AppColors.blueColor,
          onPressed: () {
            setState(() {
              showError = !isChecked;
            });
            if (isChecked) {
              getQuoteChanged();
            }
          },
        ),
      ],
    );
  }

  /// Pending Status View Widget

  pendingStatusView(){
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Text(
          "Oops! Something went wrong",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.blueColor,
            fontFamily: 'TextaAlt',
          ),
        ),
        SizedBox(
          height: h * 0.01,
        ),
        const Text(
          "Please reload this page or contact our support team.",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.blueColor,
            fontFamily: 'TextaAlt',
          ),
        ),
        SizedBox(
          height: h * 0.01,
        ),
        ButtonItem.filled(
          text: "Back to order form",
          fontSize: 20,
          textStyle: const TextStyle(
            fontSize: 22,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'TextaAlt',
          ),
          bgColor: AppColors.blueColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }


  /// Api Call
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          // timer.cancel();
          onAmountChanged(value: widget.amount.toString());
          start = 10;
          setState(() {});
        } else {
          start--;
          setState(() {});
        }
      },
    );
  }

  onAmountChanged({required String value}) async {
    Map<String, String> body = {
      "currencyPair": "${widget.coinTicker}-EUR",
      "fiatAmount": value.toString(),
      "paymentMethod": widget.paymentMethodCode,
    };
    if (value.isNotEmpty || value != "" || value != "0.0") {
      http.Response response = await Repository().getOnAmountChangedApiCall(body);
      var tempData = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        setState(() {
          price = tempData["cryptoAmount"].toString() != "null" ? tempData["cryptoAmount"].toString() : "0.00";
        });
      }
    }
  }

  getQuoteChanged() async {
    isLoading = true;
    Map<String, String> body = {"currencyPair": "${widget.coinTicker}-EUR", "fiatAmount": widget.amount.toString(), "cryptoAmount": "", "paymentMethod": widget.paymentMethodCode};
    http.Response response = await Repository().getQuoteApiCall(body);
    var tempData = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      var quoteData = tempData["quote"].toString();
      print(quoteData);
      paymentConfirm(quoteData);
    } else if (response.statusCode == 400) {
      isLoading = false;
      var errorCodeList = await AppCommonFunction().getJsonData();
      for (int i = 0; i < errorCodeList.length; i++) {
        for (int j = 0; j < tempData['errors'].length; j++) {
          if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
            AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
          }
        }
      }
      setState(() {});
    }

  }

  paymentConfirm(String quote) async {
    Map<String, String> body = {
      "quote": quote,
      "walletAddress": widget.walletAddress,
      "destinationTag": "",
      "returnUrl": "http://192.168.0.36/btcdirect.html?step=payment-completed"
    };
    var token = StorageHelper.getValue(StorageKeys.token);
    print("token :: $token");
    http.Response response = await Repository().getPaymentConfirmApiCall(body,token);
    var tempData = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 201) {
      var paymentUrl = tempData["paymentUrl"].toString();
      var orderId = tempData["orderId"].toString();
      StorageHelper.setValue(StorageKeys.orderId, orderId);
      print("orderId ::: $orderId");
      isOrderButtonTapped = true;
      launchURL(paymentUrl);
      isLoading = false;
      print("urlData ::: ${tempData.toString()}");
      setState(() {});
    }
    else if (response.statusCode == 400) {
      isLoading = false;
      log("Response ${tempData.toString()}");
      var errorCodeList = await AppCommonFunction().getJsonData();
      for (int i = 0; i < errorCodeList.length; i++) {
        for (int j = 0; j < tempData['errors'].length; j++) {
          if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
            AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
          }
        }
      }
      setState(() {});
    }
  }

  launchURL(String paymentUrl) async {
    final Uri url = Uri.parse(paymentUrl);
    launchUrl(url, mode: LaunchMode.inAppWebView).then((value) {
      print('value back web view ::: $value');
    });
    // if (!await launchUrl(url)) {
    //   throw Exception('Could not launch $url');
    // }
  }

  void paymentMethodCompleteCheckTimer() {
    const oneSec = Duration(seconds: 1);
    paymentMethodTimer = Timer.periodic(
      oneSec, (Timer timer) {
        if (paymentMethodTimerStart == 0) {
          // timer.cancel();
          getOrderDetailsData();
          paymentMethodTimerStart = 10;
          setState(() {});
        } else {
          paymentMethodTimerStart--;
          setState(() {});
        }
      },
    );
  }

  getOrderDetailsData() async{
    isLoading = true;
    var orderId = StorageHelper.getValue(StorageKeys.orderId);
    try{
      http.Response response = await Repository().getOrderDataApiCall(orderId);
      var tempData = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) {
        OrderModel orderData = OrderModel.fromJson(tempData);
        if(orderData.status == "completed"){
          isOrderPending = false;
        }
        else{
          paymentMethodTimer.cancel();
          isOrderPending = true;
        }
        isLoading = false;
        setState(() {});
      }
      else if (response.statusCode == 404) {
        isLoading = false;
        paymentMethodTimer.cancel();
        isOrderPending = true;
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              AppCommonFunction().failureSnackBar(context: context, message: '${errorCodeList[i].message}');
            }
          }
        }
        paymentMethodTimer.cancel();
        setState(() {});
      }
    }
    catch (e){
      setState(() {});
      log(e.toString());
    }
  }

}
