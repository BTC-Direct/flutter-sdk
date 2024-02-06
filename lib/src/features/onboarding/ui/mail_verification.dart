import 'package:btcdirect/src/features/onboarding/ui/verify_identity.dart';
import 'package:btcdirect/src/presentation/config_packages.dart';

class EmailVerification extends StatefulWidget {
  final String email;

  const EmailVerification({super.key, required this.email});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final smartAuth = SmartAuth();
  final pinputController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pinputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
      isAppBarLeadShow: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: h * 0.025,
                ),
                Image.asset(
                  'assets/images/email.png',
                  height: h * 0.25,
                  width: w * 0.5,
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                const Text(
                  'Email verification',
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
                Text(
                  'Enter the 6-digit code you received on your email ${widget.email}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyColor,
                    fontFamily: 'TextaAlt',
                  ),
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                Pinput(
                  controller: pinputController,
                  length: 6,
                  errorText: "Invalid code",
                  focusNode: FocusNode(),
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Invalid code';
                    }
                    return null;
                  },
                  onSubmitted: (value) {
                    debugPrint('onSubmitted: $value');
                  },
                  onCompleted: (value) {
                    debugPrint('onCompleted: $value');
                  },
                ),
                SizedBox(
                  height: h * 0.01,
                ),
                RichText(
                  text: TextSpan(
                      children: [
                        const TextSpan(text: "Didn't receive a code?  "),
                        TextSpan(
                          text: "Resend",
                          style: const TextStyle(
                            color: AppColors.blueColor,
                            fontSize: 16,
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
                        color: AppColors.greyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'TextaAlt',
                      )),
                ),
                SizedBox(
                  height: h * 0.16,
                ),
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
                    // if(formKey.currentState!.validate()){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyIdentity(),));
                    // }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifyIdentity(),
                        ));
                  },
                ),
                SizedBox(
                  height: h * 0.10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
