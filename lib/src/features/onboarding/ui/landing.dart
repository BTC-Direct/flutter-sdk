import 'package:btcdirect/src/features/onboarding/ui/signin.dart';
import 'package:btcdirect/src/presentation/config_packages.dart';

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
                'assets/images/logo.png',
                width: w * 0.60,
              ),
            ),
            SizedBox(height: h * 0.05),
            const Center(
              child: Text(
                "welcome to europe's\nfavorite crypto platform.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.black, fontSize: 24, fontFamily: 'TextaAlt', fontWeight: FontWeight.w700),
              ),
            ),
            const Spacer(),
            ButtonItem.filled(
              text: "Create account",
              fontSize: 20,
              textStyle: const TextStyle(
                fontSize: 24,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'TextaAlt',
              ),
              bgColor: AppColors.blueColor,
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
            ButtonItem.outline(
              text: "Sign in",
              textStyle: const TextStyle(
                fontSize: 24,
                color: AppColors.blueColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'TextaAlt',
              ),
              bgColor: AppColors.blueColor,
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
