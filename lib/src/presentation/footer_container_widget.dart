import 'package:btcdirect/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;

class FooterContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final String? appBarTitle;
  final bool isAppBarLeadShow;

  const FooterContainer({Key? key, this.width, this.height, this.child, this.appBarTitle, this.isAppBarLeadShow = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: isAppBarLeadShow
            ? InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.black,
                ),
              )
            : const SizedBox(),
        title: Text(
          appBarTitle ?? "",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
            fontFamily: 'TextaAlt',
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
              //padding: EdgeInsets.symmetric(horizontal: w * 0.05,),
              decoration: const BoxDecoration(
                color: AppColors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 18, bottom: 8, right: 18),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          const TextSpan(
                            text: "Powered by",
                            style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                          WidgetSpan(
                            child: Image.asset("assets/images/logo.png", height: h * 0.029,alignment: Alignment.center),
                          ),
                          const TextSpan(
                            text: " Your trusted crypto partner.\nNeed help? ",
                            style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'TextaAlt',
                            ),
                          ),
                          TextSpan(
                            text: "Contact support.",
                            style: const TextStyle(
                              color: AppColors.blueColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'TextaAlt',
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                //launchUrlString('https://support.btcdirect.eu/hc/en-gb?client=btcdirect_dev_docs');
                              },
                          )
                        ])),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 18, bottom: 8, right: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Powered by ",
                              style: TextStyle(
                                color: AppColors.greyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'TextaAlt',
                              ),
                            ),
                            Image.asset("assets/images/logo.png", height: h * 0.029, alignment: Alignment.center),
                            const Text(
                              ". Your trusted crypto partner.",
                              style: TextStyle(
                                color: AppColors.greyColor,
                                fontSize: 16,
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
                                color: AppColors.greyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'TextaAlt',
                              ),
                            ),
                            InkWell(
                              onTap: () async {
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
                              child: const Text(
                                "Contact support.",
                                style: TextStyle(
                                  color: AppColors.blueColor,
                                  fontSize: 16,
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
    );
  }
}
