import 'package:btcdirect/src/presentation/config_packages.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VerifyIdentity extends StatefulWidget {
  const VerifyIdentity({super.key});

  @override
  State<VerifyIdentity> createState() => _VerifyIdentityState();
}

class _VerifyIdentityState extends State<VerifyIdentity> {
  bool isLoading = false;
  bool isWebViewReady = false;
  late final WebViewController controller;


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
  }

  @override
  void dispose() {
    // Revert back to the default system UI mode when the screen is disposed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
      appBarTitle: isWebViewReady ? "Verify identity" :"",
      child: Padding(
        padding: isWebViewReady ? EdgeInsets.zero:EdgeInsets.symmetric(horizontal: w * 0.06),
        child: isWebViewReady
            ? webViewShow()
            : Column(
          children: [
            SizedBox(
              height: h * 0.09,
            ),
            Center(
                child: Image.asset(
              'assets/images/hand-document.png',
              height: h * 0.25,
              width: w * 0.5,
            )),
            SizedBox(
              height: h * 0.02,
            ),
            const Text(
              'Verify your identity',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontFamily: 'TextaAlt',
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            const Text(
              "Based on European legislation, BTC Direct is obliged to verify your identity. Complete your verification by uploading a valid ID card, driver's licence or passport.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.greyColor,
                fontFamily: 'TextaAlt',
              ),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            InkWell(
              onTap: () {
                bottomSheet(context);
              },
              child: const Text(
                "I don't have my ID with me ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blueColor,
                  fontFamily: 'TextaAlt',
                ),
              ),
            ),
            const Spacer(),
            ButtonItem.filled(
              text: "Continue",
              fontSize: 20,
              textStyle: const TextStyle(
                fontSize: 24,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'TextaAlt',
              ),
              bgColor: AppColors.blueColor,
              onPressed: () {
                setState(() {
                  isWebViewReady = true;
                });
              },
            ),
            SizedBox(
              height: h * 0.13,
            ),
          ],
        ),
      ),
    );
  }

  webViewShow() {
    double h = MediaQuery.of(context).size.height;
    return WebViewWidget(
      controller: controller,
    );
  }

  bottomSheet(BuildContext context) {
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
          height: h * 0.32,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
              SizedBox(height: h * 0.01),
              const Center(
                child: Text(
                  "No ID available",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'TextaAlt',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: w * 0.08, left: w * 0.08, top: 10),
                child: const Center(
                  child: Text(
                    "No worries. You can verify your ID later. You will receive a reminder via email if you didn't verify within a day.",
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
            ],
          ),
        );
      },
    );
  }
}
