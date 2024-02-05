
import 'package:btcdirect/src/presentation/config_packages.dart';

class FooterContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final String? appBarTitle;
  final bool isAppBarLeadShow;

  const FooterContainer({Key? key, this.width, this.height, this.child,this.appBarTitle, this.isAppBarLeadShow = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: isAppBarLeadShow
            ? InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: AppColors.black,),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 18, bottom: 8, right: 18),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          const TextSpan(
                            text: "Powered by",
                            style: TextStyle(color: AppColors.greyColor, fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'TextaAlt',),
                          ),
                          WidgetSpan(
                            child: Image.asset("assets/images/logo.png", height: h * 0.03),
                          ),
                          const TextSpan(
                            text: " Your trusted crypto partner.Need help? ",
                            style: TextStyle(color: AppColors.greyColor, fontSize: 14, fontWeight: FontWeight.w400,fontFamily: 'TextaAlt',),
                          ),
                          TextSpan(
                            text: "Contact support.",
                            style: const TextStyle(color: AppColors.blueColor, fontSize: 13, fontWeight: FontWeight.w400,fontFamily: 'TextaAlt',),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                //launchUrlString('https://support.btcdirect.eu/hc/en-gb?client=btcdirect_dev_docs');
                              },
                          )
                        ])),
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
