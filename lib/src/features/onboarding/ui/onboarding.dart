
import 'package:btcdirect/src/presentation/config_packages.dart';
import 'package:btcdirect/src/presentation/footerContainer_widget.dart';

import 'mail_verification.dart';


class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  bool isPersonalButton = true;
  bool isBusinessButton = false;
  bool isPasswordShow = true;
  bool isCheckBoxValue1 = false;
  bool isCheckBoxValue2 = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
      appBarTitle: "Create account",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        isBusinessButton = false;
                        isPersonalButton = !isPersonalButton;
                        setState(() {});
                      },
                      child: Container(
                        height: h * 0.06,
                        width: w * 0.38,
                        decoration: BoxDecoration(
                          color: isPersonalButton ? AppColors.backgroundColor : AppColors.transparent,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            'Personal',
                            style: TextStyle(color: isPersonalButton ? AppColors.blueColor : AppColors.greyColor, fontSize: 18, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        isPersonalButton = false;
                        isBusinessButton = !isPersonalButton;
                        setState(() {});
                      },
                      child: Container(
                        height: h * 0.06,
                        width: w * 0.38,
                        decoration: BoxDecoration(
                          color: isBusinessButton ?AppColors.backgroundColor  : AppColors.transparent,
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            'Business',
                            style: TextStyle(color: isBusinessButton ? AppColors.blueColor : AppColors.greyColor , fontSize: 18, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                personalInfoContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  businessBottomSheet(BuildContext context) {
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
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  <Widget>[
                  SizedBox(width: w, height: h * 0.04),
                 const Center(
                   child: Text(
                     "BTC Direct for business",
                     style: TextStyle(color: AppColors.black, fontSize: 22, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                   ),
                 ),
                 Padding(
                   padding:  EdgeInsets.only(right: w * 0.08, left: w * 0.08, top: 20),
                   child: const Center(
                     child: Text(
                       "Invest in cryptocurrency with your\ncompany. Before we continue please be\naware of the following requirements.",
                       textAlign: TextAlign.center,
                       style: TextStyle(color: AppColors.greyColor, fontSize: 16, fontWeight: FontWeight.w400,height: 1.2,fontFamily: 'TextaAlt',),
                     ),
                   ),
                 ),
                 Padding(
                   padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05, top: 20),
                   child: const Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Icon(Icons.location_on_outlined, color: AppColors.greyColor, size: 25,),
                       SizedBox(width: 10,),
                       Expanded(
                         child: Text(
                           "We only accept Dutch and Belgium companies.",
                           style: TextStyle(color: AppColors.greyColor, fontSize: 18, fontWeight: FontWeight.w400,fontFamily: 'TextaAlt',),
                         ),
                       ),
                     ],
                   ),
                 ),
                 Padding(
                    padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05, top: 20),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.contact_mail, color: AppColors.greyColor, size: 25,),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Text(
                            "You must be the majority shareholder of your company.",
                            style: TextStyle(color: AppColors.greyColor, fontSize: 18, fontWeight: FontWeight.w400,fontFamily: 'TextaAlt',),
                          ),
                        ),
                      ],
                    ),
                  ),
                 Padding(
                    padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05, top: 20),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.email_outlined, color: AppColors.greyColor, size: 25,),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Text(
                            "After signing up we need to verify your information. Once we're done we send you an email with information on how to complete your business account.",
                            style: TextStyle(color: AppColors.greyColor, fontSize: 16, fontWeight: FontWeight.w400,fontFamily: 'TextaAlt',),
                          ),
                        ),
                      ],
                    ),
                  ),
                 SizedBox(height: h * 0.03,),
                 Padding(
                   padding: EdgeInsets.only(right: h * 0.03 , left: h * 0.03),
                   child: ButtonItem.filled(
                      text: "Close",
                      fontSize: 20,
                      textStyle: const TextStyle(fontSize: 24,color: AppColors.white,fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                      bgColor: AppColors.blueColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                 ),
                 SizedBox(height: h * 0.04,),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close, color: AppColors.black, size: 26,),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  personalInfoContainer() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(isBusinessButton)
        SizedBox(height: h * 0.03,),
        if(isBusinessButton)
        ButtonItem.outline(
          text: "BTC Direct for business",
          icon: const Icon(Icons.info_outline, color: AppColors.blueColor, size: 20,),
          textStyle: const TextStyle(
              fontSize: 20,
              color: AppColors.blueColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'TextaAlt',
          ),
          width: w * 0.9,
          bgColor: AppColors.blueColor,
          onPressed: () {
            businessBottomSheet(context);
          },
        ),
        SizedBox(height: h * 0.03,),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "First name",
                    style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                  ),
                  SizedBox(
                    height: h * 0.012,
                  ),
                  CommonTextFormField(
                    textEditingController: firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: w * 0.06,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Last name",
                    style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                  ),
                  SizedBox(
                    height: h * 0.012,
                  ),
                  CommonTextFormField(
                    textEditingController: lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: h * 0.03,
        ),
        const Text(
          "Email",
          style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
        ),
        SizedBox(
          height: h * 0.012,
        ),
        CommonTextFormField(
          textEditingController: emailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            } else if (!value.contains('@')) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        SizedBox(
          height: h * 0.03,
        ),
        const Text(
          "Nationality",
          style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
        ),
        SizedBox(
          height: h * 0.012,
        ),
        Container(
          width: w,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  "Netherlands",
                  style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: h * 0.03,
        ),
        const Row(
          children: [
            Text(
              "Password",
              style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
            ),
            Spacer(),
            Text(
              "Minimum of 8 characters",
              style: TextStyle(color: AppColors.greyColor, fontSize: 12, fontWeight: FontWeight.w400,fontFamily: 'TextaAlt',),
            ),
          ],
        ),
        SizedBox(
          height: h * 0.012,
        ),
        CommonTextFormField(
          textEditingController: passwordController,
          validator: (p1) => FieldValidator.validatePassword(p1, text: "This field is required", validText: "Please enter valid password"),
          obscure: isPasswordShow,
          suffix: GestureDetector(
            onTap: () {
              if (isPasswordShow) {
                isPasswordShow = false;
                setState(() {});
              } else {
                isPasswordShow = true;
                setState(() {});
              }
            },
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Icon(
                  isPasswordShow ? Icons.visibility_off : Icons.visibility,
                )),
          ),
        ),
        SizedBox(
          height: h * 0.03,
        ),
        Row(
          children: [
            Checkbox(
              value: isCheckBoxValue1,
              onChanged: (value) {
                isCheckBoxValue1 = value!;
                setState(() {});
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
                text: TextSpan(children: [
                  const TextSpan(text: "I agree to the "),
                  TextSpan(
                    text: "terms and conditions",
                    style: const TextStyle(color: AppColors.blueColor, fontSize: 15, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        //launchUrlString('https://blockx. gitbook.io/blocx./get-started/masternode#vps-console-putty-or-terminal');
                      },
                  ),
                  const TextSpan(text: " and "),
                  TextSpan(
                    text: "privacy policy",
                    style: const TextStyle(color: AppColors.blueColor, fontSize: 15, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        //launchUrlString('https://blockx. gitbook.io/blocx./get-started/masternode#vps-console-putty-or-terminal');
                      },
                  ),
                  const TextSpan(text: "."),
                ], style: const TextStyle(color: AppColors.black, fontSize: 15, fontWeight: FontWeight.w500,fontFamily: 'TextaAlt',)),
              ),
            ),
          ],
        ),
        Visibility(
          visible: isCheckBoxValue1,
          child: Padding(
            padding:  EdgeInsets.only(left: w * 0.06),
            child: const Text(
              textAlign: TextAlign.center,
                "Please check the checkbox to continue.",
                style: TextStyle(color: AppColors.redColor, fontSize: 13, fontWeight: FontWeight.w500,fontFamily: 'TextaAlt',),
            ),
          ),
        ),
        SizedBox(
          height: h * 0.03,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: isCheckBoxValue2,
              onChanged: (value) {
                isCheckBoxValue2 = value!;
                setState(() {});
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
            SizedBox(
              width: w * 0.76,
              child: const Text(
                "Yes, I would like to regularly receive the newsletter by email and be informed about offers and promotions.",
                style: TextStyle(color: AppColors.black, fontSize: 15, fontWeight: FontWeight.w500,fontFamily: 'TextaAlt',),
              ),
            ),
          ],
        ),
        SizedBox(height: h * 0.03,),
        ButtonItem.filled(
          text: "Continue",
          fontSize: 20,
          textStyle: const TextStyle(fontSize: 24,color: AppColors.white,fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
          bgColor: AppColors.blueColor,
          onPressed: () {
            // if(formKey.currentState!.validate()){
            //   if(isCheckBoxValue1){
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => EmailVerification(email: emailController.text),));
            //   }
            // }
            Navigator.push(context, MaterialPageRoute(builder: (context) => EmailVerification(email: "dhruvin182@yopmail.com" /*emailController.text*/),));
          },
        ),
        SizedBox(height: h * 0.12,),
      ],
    );
  }

}
