import 'package:btc_direct/src/features/onboarding/ui/signin.dart';
import 'package:btc_direct/src/presentation/config_packages.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
      isAppBarLeadShow: true,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.06,
        ),
        child: Column(
          children: [
            SizedBox(height: h * 0.05),
            Center(
              child: Image.asset(
                Images.btcDirectIcon,
                width: w * 0.60,
              ),
            ),
            SizedBox(height: h * 0.05),
            const Center(
              child: Text(
                "Welcome to europe's\nfavorite crypto platform.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CommonColors.black,
                    fontSize: 24,
                    fontFamily: 'TextaAlt',
                    package: "btc_direct",
                    fontWeight: FontWeight.w700),
              ),
            ),
            const Spacer(),
            CommonButtonItem.filled(
              text: "Create account",
              fontSize: 20,
              textStyle: const TextStyle(
                fontSize: 24,
                color: CommonColors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'TextaAlt',
                package: "btc_direct",
              ),
              bgColor: CommonColors.blueColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnBoarding(),
                  ),
                );
              },
            ),
            SizedBox(height: h * 0.03),
            CommonButtonItem.outline(
              text: "Sign in",
              textStyle: const TextStyle(
                fontSize: 24,
                color: CommonColors.blueColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'TextaAlt',
                package: "btc_direct",
              ),
              bgColor: CommonColors.blueColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignIn(),
                  ),
                ).then((value) {});
              },
            ),
            SizedBox(height: h * 0.12),
          ],
        ),
      ),
    );
  }
}
