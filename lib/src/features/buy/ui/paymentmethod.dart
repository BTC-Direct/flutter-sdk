import 'dart:developer';
import 'dart:io';

import 'package:btcdirect/src/core/model/order_model.dart';
import 'package:btcdirect/src/features/buy/ui/completePayment.dart';
import 'package:btcdirect/src/presentation/config_packages.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:http/http.dart' as http;


class PaymentMethod extends StatefulWidget {
  String amount;
  String paymentMethodCode;
  String walletAddress;
  String walletName;
  String paymentMethodName;
  String coinTicker;
  String paymentFees;
  String networkFees;

  PaymentMethod(
      {super.key,
      required this.amount,
      required this.paymentMethodCode,
      required this.walletAddress,
      required this.walletName,
      required this.paymentMethodName,
      required this.coinTicker,
      required this.paymentFees,
      required this.networkFees});

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
  bool isOrderCancelled = false;
  bool isWebViewReady = false;
  bool isWebControllerCall = false;
  late Timer timer;
  late Timer paymentMethodTimer;
  int start = 10;
  int paymentMethodTimerStart = 5;
  String price = "0.0";
  num totalFees = 0.0;
  String webViewUrl = "";
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    onAmountChanged(value: widget.amount);
    startTimer();
    isTimerShow = true;
    totalFees = double.parse(widget.paymentFees) + double.parse(widget.networkFees);
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
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
    return isWebViewReady
        ? webViewShow()
        : FooterContainer(
            appBarTitle: "Checkout",
            isAppBarLeadShow: true,
            child: SingleChildScrollView(
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
                        : isOrderPending
                            ? pendingStatusView()
                            : paymentView(),
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
              "${widget.coinTicker} $price",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
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
              fontSize: 24,
              fontWeight: FontWeight.w700,
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
              Text(
                '€${totalFees.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  fontFamily: 'TextaAlt',
                ),
              ),
              const Spacer(),
              Text(
                showAllFees ? 'Hide details' : 'View details',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blueColor,
                  fontFamily: 'TextaAlt',
                  //decoration: TextDecoration.underline,
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
            height: showAllFees ? 125.0 : 0.0,
            width: w,
            color: AppColors.backgroundColor.withOpacity(0.4),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          width: 6,
                        ),
                        IconButton(
                          onPressed: () {
                            paymentMethodInfoBottomSheet(context);
                          },
                          icon: const Icon(
                            Icons.info_sharp,
                            size: 20,
                          ),
                          color: AppColors.greyColor,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Center(
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
                        const SizedBox(
                          width: 6,
                        ),
                        IconButton(
                          onPressed: () {
                            networkFeeInfoBottomSheet(context);
                          },
                          icon: const Icon(
                            Icons.info_sharp,
                            size: 20,
                          ),
                          color: AppColors.greyColor,
                        ),
                        const Spacer(),
                        Text(
                          "€${widget.networkFees}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyColor,
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
                              color: AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                        ),
                        Text(
                          "€${totalFees.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
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
                widget.amount.isEmpty ? "€0.00" : "€${double.parse(widget.amount).toStringAsFixed(2)}",
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'TextaAlt',
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            http.Response response = await Repository().getClientInfoApiCall();
                            if (response.statusCode == 200) {
                              var tempData = jsonDecode(response.body)['slug'];
                              final Uri url = Uri.parse("https://btcdirect.eu/en-eu/terms-of-service?client=$tempData");
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            }
                          },
                      ),
                      const TextSpan(text: "."),
                    ],
                    style: const TextStyle(
                      color: AppColors.black,
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
                color: AppColors.redColor,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'TextaAlt',
              ),
            ),
          ),
        ),
        SizedBox(
          height: h * 0.09,
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
        SizedBox(
          height: h * 0.12,
        ),
      ],
    );
  }

  paymentMethodInfoBottomSheet(BuildContext context) {
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
                      color: AppColors.black,
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
                    color: AppColors.black,
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
                    "Payment method fees depend on the payment\nmethod selected. These fees are charged to us\nby the payment processor. Tip: Check carefully\nwhat is most advantageous for you and save on your purchase.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'TextaAlt',
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

  networkFeeInfoBottomSheet(BuildContext context) {
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
                      color: AppColors.black,
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
                    color: AppColors.black,
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
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'TextaAlt',
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

  /// Pending Status View Widget

  pendingStatusView() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: h * 0.02,
        ),
        SvgPicture.asset(
          'assets/images/error.svg',
          width: w * 0.2,
          height: h * 0.15,
        ),
        SizedBox(
          height: h * 0.02,
        ),
        Text(
          isOrderCancelled ? "Oops! Your order\nhas been cancelled" : "Oops! Something went\nwrong",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            fontFamily: 'TextaAlt',
          ),
        ),
        SizedBox(
          height: h * 0.02,
        ),
        isOrderCancelled
            ? Container()
            : const Text(
                "Please reload this page or contact our\nsupport team.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  fontFamily: 'TextaAlt',
                ),
              ),
        SizedBox(
          height: h * 0.2,
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

  /// webView widget

  webViewShow() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: h,
      width: w,
      child: WebView(
        initialUrl: webViewUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {},
        javascriptChannels: const <JavascriptChannel>{},
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://www.btcdirectapp.com')) {
            isWebViewReady = false;
            paymentMethodCompleteCheckTimer();
            setState(() {});
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          // isLoading = true;
          // setState(() {});
        },
        backgroundColor: Colors.white,
      ),
    );
  }

  /// Api Call
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
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
    http.Response response = await Repository().getQuoteApiCall(body, context);
    var tempData = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      var quoteData = tempData["quote"].toString();
      paymentConfirm(quoteData);
    }
  }

  paymentConfirm(String quote) async {
    Map<String, String> body = {"quote": quote, "walletAddress": widget.walletAddress, "destinationTag": "", "returnUrl": "https://www.btcdirectapp.com"};
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response = await Repository().getPaymentConfirmApiCall(body, token, context);
    var tempData = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 201) {
      var paymentUrl = tempData["paymentUrl"].toString();
      var orderId = tempData["orderId"].toString();
      StorageHelper.setValue(StorageKeys.orderId, orderId);
      webViewUrl = paymentUrl;
      isWebViewReady = true;
      setState(() {});
    }
  }

  /// Payment Method Complete Are Not Check Api Call

  void paymentMethodCompleteCheckTimer() {
    const oneSec = Duration(seconds: 1);
    paymentMethodTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (paymentMethodTimerStart == 0) {
          // timer.cancel();
          getOrderDetailsData();
          paymentMethodTimerStart = 5;
          setState(() {});
        } else {
          paymentMethodTimerStart--;
          setState(() {});
        }
      },
    );
  }

  getOrderDetailsData() async {
    isLoading = true;
    var orderId = StorageHelper.getValue(StorageKeys.orderId);
    try {
      http.Response response = await Repository().getOrderDataApiCall(orderId, context);
      var tempData = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        OrderModel orderData = OrderModel.fromJson(tempData);
        if (orderData.status == "completed") {
          isOrderPending = false;
          isOrderCancelled = false;
          paymentMethodTimer.cancel();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CompletePayment()));
        } else if (orderData.status == "cancelled") {
          paymentMethodTimer.cancel();
          isOrderPending = true;
          isOrderCancelled = true;
        } else if (orderData.status == "pending") {
          paymentMethodTimer.cancel();
          isOrderPending = true;
        }
        isLoading = false;
        setState(() {});
      }
    } catch (e) {
      setState(() {});
      log(e.toString());
    }
  }
}
