import 'dart:developer';
import 'dart:io';
import 'package:btc_direct/src/core/model/order_model.dart';
import 'package:btc_direct/src/features/buy/ui/complete_payment.dart';
import 'package:btc_direct/src/presentation/config_packages.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:http/http.dart' as http;

/// The stateless widget for displaying the payment method screen of the Btc Direct.
/// This widget takes the following parameters:
/// - `amount`: The amount of fiat or cryptocurrency currency
/// - `paymentMethodCode`: The code of the payment method
/// - `walletAddress`: The wallet address of the user
/// - `walletName`: The name of the wallet
/// - `paymentMethodName`: The name of the payment method
/// - `coinTicker`: The ticker of the cryptocurrency coin
/// - `paymentFees`: The fees of the payment method
/// - `networkFees`: The network fees
/// The widget displays the payment method information, including the amount, payment method name, wallet address, and fees.
/// It also displays a web view of the payment method's payment page.
/// The widget does not return any widget.
// ignore: must_be_immutable
class PaymentMethod extends StatefulWidget {
  String amount;
  String paymentMethodCode;
  String walletAddress;
  String walletName;
  String paymentMethodName;
  String coinTicker;
  String paymentFees;
  String networkFees;

  PaymentMethod({
    super.key,
    required this.amount,
    required this.paymentMethodCode,
    required this.walletAddress,
    required this.walletName,
    required this.paymentMethodName,
    required this.coinTicker,
    required this.paymentFees,
    required this.networkFees,
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  /// State variables for PaymentMethod widget
  /// - isTimerShow: indicates whether the timer is showing or not
  /// - showAllFees: indicates whether to show all fees or not
  /// - isChecked: indicates whether the checkbox is checked or not
  /// - showError: indicates whether to show error or not
  /// - isLoading: indicates whether the API call is in progress or not
  /// - isOrderPending: indicates whether the order is pending or not
  /// - isOrderCancelled: indicates whether the order is cancelled or not
  /// - isWebViewReady: indicates whether the webview is ready or not
  /// - isWebControllerCall: indicates whether the web controller is called or not
  /// - start: timer start value
  /// - paymentMethodTimerStart: timer start value for payment method
  /// - price: price value
  /// - totalFees: total fees value
  /// - webViewUrl: webview url
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
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override

  /// Initializes the state of the widget.
  ///
  /// This function is called when the widget is inserted into the tree. It performs the following actions:
  /// - Calls the `onAmountChanged` function with the `value` parameter set to `widget.amount`.
  /// - Starts the timer using the `startTimer` function.
  /// - Sets the `isTimerShow` variable to `true`.
  /// - Calculates the `totalFees` by parsing the `widget.paymentFees` and `widget.networkFees` strings as doubles and adding them together.
  /// - If the platform is Android, sets the `WebView.platform` to `SurfaceAndroidWebView`.
  /// - Calls the `super.initState()` function to perform any additional initialization.
  void initState() {
    onAmountChanged(value: widget.amount);
    startTimer();
    isTimerShow = true;
    totalFees =
        double.parse(widget.paymentFees) + double.parse(widget.networkFees);
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
                        ? SizedBox(
                            height: h / 1.5,
                            child: const Center(
                                child: CircularProgressIndicator()))
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
                color: CommonColors.blueColor,
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
            const Text(
              "Payment",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: CommonColors.blueColor,
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
              "Complete",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: CommonColors.greyColor.withOpacity(0.6),
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
                color: CommonColors.greyColor.withOpacity(0.6),
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
            color: CommonColors.black,
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
                color: CommonColors.black,
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
                        color: CommonColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'TextaAlt',
                      ),
                    ),
                    const TextSpan(text: "s"),
                  ],
                  style: const TextStyle(
                    color: CommonColors.greyColor,
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
              color: CommonColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        Text(
          '${widget.walletName} - ${AppCommonFunction().truncateStringWithEllipsis(widget.walletAddress, 10, 5)}',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: CommonColors.black,
            fontFamily: 'TextaAlt',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.01),
          child: const Text(
            "Payment method",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: CommonColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        Row(
          children: [
            SvgPicture.network(
              isSandBox
                  ? 'https://widgets-sandbox.btcdirect.eu/img/payment-methods/${widget.paymentMethodCode}.svg'
                  : 'https://widgets-sandbox.btcdirect.eu/img/payment-methods/${widget.paymentMethodCode}.svg',
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
                color: CommonColors.black,
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
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: CommonColors.black,
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
                  color: CommonColors.black,
                  fontFamily: 'TextaAlt',
                ),
              ),
              const Spacer(),
              Text(
                showAllFees ? 'Hide details' : 'View details',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: CommonColors.blueColor,
                  fontFamily: 'TextaAlt',
                  //decoration: TextDecoration.underline,
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
                              color: CommonColors.greyColor,
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
                          color: CommonColors.greyColor,
                        ),
                        const Spacer(),
                        Text(
                          "€${widget.paymentFees}",
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
                          color: CommonColors.greyColor,
                        ),
                        const Spacer(),
                        Text(
                          "€${widget.networkFees}",
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
                            fontSize: 20,
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
        Padding(
          padding: EdgeInsets.only(top: h * 0.04, bottom: h * 0.01),
          child: Row(
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: CommonColors.black,
                  fontFamily: 'TextaAlt',
                ),
              ),
              const Spacer(),
              Text(
                widget.amount.isEmpty
                    ? "€0.00"
                    : "€${double.parse(widget.amount).toStringAsFixed(2)}",
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
              side: const BorderSide(color: CommonColors.greyColor, width: 1.5),
              activeColor: CommonColors.blueColor,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                    children: [
                      const TextSpan(text: "I accept the "),
                      TextSpan(
                        text: "general terms and conditions",
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
        CommonButtonItem.filled(
          text: "Continue order",
          fontSize: 20,
          textStyle: const TextStyle(
            fontSize: 22,
            color: CommonColors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'TextaAlt',
          ),
          bgColor: CommonColors.blueColor,
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

  /// Displays a bottom sheet with payment method information.
  ///
  /// This function displays a bottom sheet with the title "Payment method"
  /// and a message explaining how the fees for payment methods work.
  ///
  /// The message is centered and has a font size of 17. The text is
  /// black and has a font weight of 400.
  ///
  /// The bottom sheet is scrollable and has a height of 30% of the
  /// screen height.
  ///
  /// The bottom sheet has a close icon in the top right corner which
  /// can be tapped to dismiss the bottom sheet.
  ///
  /// [context]: The context of the widget.
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
                        fontSize: 17,
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

  /// Displays a bottom sheet with information about network fees.
  /// Shows a bottom sheet with title "Network fee" and text explaining the purpose
  /// of network fees in Bitcoin transactions. The bottom sheet can be closed by
  /// tapping the close button in the top right corner.
  /// This will display a bottom sheet with the title "Network fee" and the
  /// explanation text about network fees. The bottom sheet can be closed by tapping
  /// the close button in the top right corner.
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
          Images.errorIcon,
          width: w * 0.2,
          height: h * 0.15,
        ),
        SizedBox(
          height: h * 0.02,
        ),
        Text(
          isOrderCancelled
              ? "Oops! Your order\nhas been cancelled"
              : "Oops! Something went\nwrong",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: CommonColors.black,
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
                  color: CommonColors.black,
                  fontFamily: 'TextaAlt',
                ),
              ),
        SizedBox(
          height: h * 0.2,
        ),
        CommonButtonItem.filled(
          text: "Back to order form",
          fontSize: 20,
          textStyle: const TextStyle(
            fontSize: 22,
            color: CommonColors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'TextaAlt',
          ),
          bgColor: CommonColors.blueColor,
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
          if (kDebugMode) {
            print('Page started loading: $url');
          }
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
  /// Starts a timer that periodically calls the `onAmountChanged` function.
  ///
  /// The timer is set to run every second. When the timer ticks, it checks if the `start` variable is 0.
  /// If it is, it calls the `onAmountChanged` function with the `widget.amount` as the value,
  /// sets the `start` variable to 10, and updates the state.
  /// If the `start` variable is not 0, it decrements the `start` variable and updates the state.
  ///
  /// This function does not take any parameters and does not return anything.
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
      http.Response response =
          await Repository().getOnAmountChangedApiCall(body);
      var tempData = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        setState(() {
          price = tempData["cryptoAmount"].toString() != "null"
              ? tempData["cryptoAmount"].toString()
              : "0.00";
        });
      }
    }
  }

  getQuoteChanged() async {
    isLoading = true;
    Map<String, String> body = {
      "currencyPair": "${widget.coinTicker}-EUR",
      "fiatAmount": widget.amount.toString(),
      "cryptoAmount": "",
      "paymentMethod": widget.paymentMethodCode
    };
    http.Response response = await Repository().getQuoteApiCall(body, context);
    var tempData = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      var quoteData = tempData["quote"].toString();
      paymentConfirm(quoteData);
    }
  }

  /// Calls the payment confirm API with the given quote and updates the state
  /// accordingly.
  /// The API is called with the quote, wallet address, destination tag, and return
  /// URL.
  /// The response is then parsed and the payment URL and order ID are stored in
  /// the state.
  /// If the API call is successful, the state is updated and the widget is rebuilt.
  /// The function takes one parameter: `quote` which is the quote to be used in
  /// the API call.
  /// [quote]: The quote to be used in the API call.
  paymentConfirm(String quote) async {
    Map<String, String> body = {
      "quote": quote,
      "walletAddress": widget.walletAddress,
      "destinationTag": "",
      "returnUrl": "https://www.btcdirectapp.com"
    };
    var token = StorageHelper.getValue(StorageKeys.token);
    http.Response response =
        await Repository().getPaymentConfirmApiCall(body, token, context);
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

  /// Retrieves order details data from the API and updates the state accordingly.
  /// This function calls the `getOrderDataApiCall` function from the Repository class
  /// and decodes the response body into an `OrderModel`.
  /// It then checks the order status and updates the state accordingly.
  /// If the order status is "completed", it navigates to the CompletePayment screen.
  /// If the order status is "cancelled", it sets the `isOrderPending` and `isOrderCancelled`
  /// variables to `true`. If the order status is "pending", it sets the `isOrderPending`
  /// variable to `true`.
  /// Finally, it calls `setState` to update the UI.
  /// This function takes no parameters and does not return anything.
  ///
  /// Throws a [StateError] if the widget is not mounted when the function is called.
  ///
  /// Throws a [FormatException] if the order data is invalid.
  ///
  getOrderDetailsData() async {
    isLoading = true;
    var orderId = StorageHelper.getValue(StorageKeys.orderId);
    try {
      http.Response response =
          await Repository().getOrderDataApiCall(orderId, context);
      var tempData = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        OrderModel orderData = OrderModel.fromJson(tempData);
        if (orderData.status == "completed") {
          isOrderPending = false;
          isOrderCancelled = false;
          paymentMethodTimer.cancel();
          if (mounted) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CompletePayment()));
          }
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
