import 'package:btc_direct/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;

class FooterContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final String? appBarTitle;
  final bool isAppBarLeadShow;

  const FooterContainer(
      {super.key,
      this.width,
      this.height,
      this.child,
      this.appBarTitle,
      this.isAppBarLeadShow = false});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return CommonFontDimen(
      child: Scaffold(
        backgroundColor: CommonColors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: CommonColors.white,
          foregroundColor: CommonColors.white,
          elevation: 0,
          leading: isAppBarLeadShow
              ? InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: CommonColors.black,
                  ),
                )
              : const SizedBox(),
          title: Text(
            appBarTitle ?? "",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: CommonColors.black,
              fontFamily: 'TextaAlt',
              package: "btc_direct",
            ),
          ),
        ),
        body: Stack(
          children: [
            child!,
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: h * 0.10,
                width: w,
                decoration: const BoxDecoration(
                  color: CommonColors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, top: 18, bottom: 6, right: 18),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            const TextSpan(
                              text: "Powered by",
                              style: TextStyle(
                                color: CommonColors.greyColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'TextaAlt',
                                package: "btc_direct",
                              ),
                            ),
                            WidgetSpan(
                              child: Image(
                                image: const AssetImage(Images.btcDirectIcon),
                                height: h * 0.03,
                              ),
                            ),
                            const TextSpan(
                              text: " Your trusted crypto partner.Need help? ",
                              style: TextStyle(
                                color: CommonColors.greyColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'TextaAlt',
                                package: "btc_direct",
                              ),
                            ),
                            TextSpan(
                              text: "Contact support.",
                              style: const TextStyle(
                                color: CommonColors.blueColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'TextaAlt',
                                package: "btc_direct",
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  http.Response response =
                                      await Repository().getClientInfoApiCall();
                                  if (response.statusCode == 200) {
                                    var tempData =
                                        jsonDecode(response.body)['slug'];
                                    final Uri url = Uri.parse("https://support.btcdirect.eu/hc/en-gb?client=$tempData");
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  }
                                },
                            )
                          ])),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0, top: 18, bottom: 8, right: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Powered by ",
                                style: TextStyle(
                                  color: CommonColors.greyColor,
                                  fontSize: 14 ,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'TextaAlt',
                                ),
                              ),
                              Image.asset(Images.btcDirectIcon, height: h * 0.029, alignment: Alignment.center),
                              const Text(
                                ". Your trusted crypto partner.",
                                style: TextStyle(
                                  color: CommonColors.greyColor,
                                  fontSize: 14 ,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'TextaAlt',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Need help? ",
                                style: TextStyle(
                                  color: CommonColors.greyColor,
                                  fontSize: 14 ,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'TextaAlt',
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  http.Response response =
                                  await Repository().getClientInfoApiCall();
                                  if (response.statusCode == 200) {
                                    var tempData = jsonDecode(response.body)['slug'];
                                    final Uri url = Uri.parse("https://support.btcdirect.eu/hc/en-gb?client=$tempData");
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  }
                                },
                                child: const Text(
                                  "Contact support.",
                                  style: TextStyle(
                                    color: CommonColors.blueColor,
                                    fontSize: 16 ,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'TextaAlt',
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
