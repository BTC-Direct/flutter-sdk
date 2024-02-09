import 'dart:developer';

import 'package:btcdirect/src/core/model/get_pairs_model.dart';
import 'package:btcdirect/src/core/model/get_paymentMethod_model.dart';
import 'package:btcdirect/src/features/onboarding/ui/landing.dart';
import 'package:btcdirect/src/features/onboarding/ui/onboarding.dart';
import 'package:btcdirect/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;

class Buy extends StatefulWidget {
  const Buy({super.key});

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  int indexValue = 0;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController coinAmount = TextEditingController();
  TextEditingController walletAddress = TextEditingController();
  TextEditingController paymentMethod = TextEditingController();
  int coinSelectIndex = 0;
  int paymentSelectIndex = 0;
  late Timer timer;
  int start = 10;
  double price = 0.0;
  bool isLoading = false;
  bool isTimerShow = false;
  bool showAllFees = false;
  bool isAmountValid = false;
  List<CoinModel> coinList = [];
  List<PaymentMethods> payMethodList = [];


  @override
  void initState() {
    super.initState();
    getCurrencyPairs();
    walletAddress = TextEditingController(text: "My wallet");
    startTimer();
    isTimerShow = true;
  }

  @override
  void dispose() {
    timer.cancel();
    print("timerDispose");
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
      appBarTitle: "Checkout",
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: h * 0.01,),
                topContainerView(),
                SizedBox(height: h * 0.04,),
                isLoading ? const Center(child: CircularProgressIndicator()) : orderView(),
                SizedBox(height: h * 0.13,),
              ],
            ),
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
            Text(
              "Order",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: indexValue == 0 ? AppColors.blueColor : AppColors.greyColor.withOpacity(0.6),
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
              "Payment",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: indexValue == 1 ? AppColors.blueColor : AppColors.greyColor.withOpacity(0.6),
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
                color: indexValue == 1 ? AppColors.blueColor : AppColors.greyColor.withOpacity(0.6),
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
                color: indexValue == 2 ? AppColors.blueColor : AppColors.greyColor.withOpacity(0.6),
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
                color: indexValue == 2 ? AppColors.blueColor : AppColors.greyColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  orderView() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: isAmountValid,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.015),
            child: RichText(
              text: TextSpan(
                  children: [
                    const TextSpan(text: "Your order must be at least €30.00. "),
                    TextSpan(
                      text: "Click here ",
                      style: const TextStyle(
                        color: AppColors.blueColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'TextaAlt',
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          amount.text = "30";
                          onAmountChanged(value: "30", isPay: true);
                          isAmountValid = false;
                        },
                    ),
                    const TextSpan(text: "to automatically fill in the minimum amount of €30.00."),
                  ],
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'TextaAlt',
                  )),
            ),
          ),
            ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.01),
          child: const Text(
            "You pay",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        CommonTextFormField(
          textEditingController: amount,
          keyBoardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: "min. €30.00",
          onChanged: (p0) {
            if (p0.isNotEmpty || p0 != "") {
              final double enteredValue = double.parse(p0);
              if(enteredValue >= 30){
                  isAmountValid = false;
                  onAmountChanged(value: p0, isPay: true);
              }else{
                isAmountValid = true;
              }
            }
          },
          suffix: Container(
            width: 100,
            margin: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(color: AppColors.darkBlueColor, shape: BoxShape.circle),
                  child: const Text(
                    "€",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                const Text(
                  "EUR",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    fontFamily: 'TextaAlt',
                  ),
                ),
              ],
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Amount is required';
            }else if(double.parse(value) < 30){
              return "The minimum amount is €30.00";
            }else{
              return null;
            }
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.01),
          child: const Text(
            "You get",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        CommonTextFormField(
          textEditingController: coinAmount,
          keyBoardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (p0) {
            if (p0.isNotEmpty || p0 != "") {
              onAmountChanged(value: p0, isPay: false);
            } else {
              amount.clear();
            }
          },
          suffix: Container(
            width: 100,
            margin: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: InkWell(
              onTap: () {
                coinSelectBottomSheet(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    coinSelectIndex == 0 ? '${coinList.first.coinIcon}' : '${coinList[coinSelectIndex].coinIcon}',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    coinSelectIndex == 0 ? "${coinList.first.coinTicker}" : "${coinList[coinSelectIndex].coinTicker}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.black,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Amount is required';
            }
            return null;
          },
          onEditingComplete: () {
            // startTimer();
            // isTimerShow = true;
            // setState(() {});
          },
        ),
        SizedBox(
          height: h * 0.01,
        ),
        Row(
          children: [
            if (isTimerShow && start > 0)
              Icon(
                Icons.watch_later_outlined,
                color: AppColors.greyColor,
                size: h * 0.022,
              )
            else
              SizedBox(height: h * 0.015, width: h * 0.015, child: const CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.greyColor)),
            if (isTimerShow)
              Text(
                " Refresh in ${start}s",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.greyColor,
                  fontFamily: 'TextaAlt',
                ),
              ),
            const Spacer(),
            Text(
              "${coinList[coinSelectIndex].coinTicker} €$price",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.greyColor,
                fontFamily: 'TextaAlt',
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.01),
          child: const Text(
            "Your wallet address",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        CommonTextFormField(
          textEditingController: walletAddress,
          readOnly: true,
          prefix: SizedBox(
            width: 60,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.02,vertical: h * 0.01),
              child: SvgPicture.network(
                '${coinList[coinSelectIndex].coinIcon}',
                width: 25,
                height: 25,
              ),
            ),
          ),
          suffix: const Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.greyColor),
          onTap: () {
            //nationalitySelectBottomSheet(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Chooes your wallet address.';
            }
            return null;
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.015, bottom: h * 0.01),
          child: const Text(
            "Select payment method",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontFamily: 'TextaAlt',
            ),
          ),
        ),
        CommonTextFormField(
          textEditingController: paymentMethod,
          readOnly: true,
          prefix: SizedBox(
            width: 60,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.02),
              child: SvgPicture.network(
                '${payMethodList[paymentSelectIndex].code}',
                width: 30,
                height: 30,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          suffix: const Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.greyColor),
          onTap: () {
            paymentMethodBottomSheet(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Select your payment method.';
            }
            return null;
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: h * 0.04, bottom: h * 0.01),
          child: Row(
            children: [
              const Text(
                "Total amount:",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  fontFamily: 'TextaAlt',
                ),
              ),
              const Spacer(),
              Text(
                "€${amount.text}.00",
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
        GestureDetector(
          onTap: () {
            setState(() {
              showAllFees = !showAllFees;
            });
          },
          child: Row(
            children: [
              const Spacer(),
              Text(
                showAllFees ? 'Hide Fees' : 'All Fees Included',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blueColor,
                  fontFamily: 'TextaAlt',
                  decoration: TextDecoration.underline,
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
            height: showAllFees ? 120.0 : 0.0,
            width: w,
            color: AppColors.backgroundColor.withOpacity(0.4),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Center(
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
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.info_sharp,
                          color: AppColors.greyColor,
                          size: 20,
                        ),
                        Spacer(),
                        Text(
                          "€0.00",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyColor,
                            fontFamily: 'TextaAlt',
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
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
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.info_sharp,
                          color: AppColors.greyColor,
                          size: 20,
                        ),
                        Spacer(),
                        Text(
                          "€0.00",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyColor,
                            fontFamily: 'TextaAlt',
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
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
                          "€0.00",
                          style: TextStyle(
                            fontSize: 18,
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
        SizedBox(height: showAllFees ? 35.0 : h * 0.18,),
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
            if(formKey.currentState!.validate()){
              timer.cancel();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Landing(),
                ),
              ).then((value) {
                startTimer();
              });
            }
            // getCurrencyPrice();
            // indexValue++;
            // setState(() {});
          },
        ),
      ],
    );
  }

  paymentView() {
    double h = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "You pay",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            fontFamily: 'TextaAlt',
          ),
        ),
        SizedBox(
          height: h * 0.01,
        ),
        /*CommonTextFormField(
            textEditingController: amount,
            hintText: "min. €30.00",
            suffix: Container(
              width: 100,
              margin: const EdgeInsets.all(1),
              decoration: const BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30,width: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.darkBlueColor,
                      shape: BoxShape.circle
                    ),
                    child: const Text(
                      "€",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                        fontFamily: 'TextaAlt',),
                    ),
                  ),
                  const SizedBox(width: 6,),
                  const Text(
                    "EUR",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      fontFamily: 'TextaAlt',),
                  ),
                ],
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Amount is required';
              }
              return null;
            },
        ),
        SizedBox(height: h * 0.03),
        const Text(
          "You get",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            fontFamily: 'TextaAlt',),
        ),
        SizedBox(height: h * 0.01,),
        CommonTextFormField(
          textEditingController: coinAmount,
          suffix: Container(
            width: 100,
            margin: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: InkWell(
              onTap: (){
                coinSelectBottomSheet(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.network(coinSelectIndex == 0 ? '${coinList.first.coinIcon}' :'${coinList[coinSelectIndex].coinIcon}', width: 30, height: 30,),
                  const SizedBox(width: 6,),
                   Text(
                     coinSelectIndex == 0 ? "${coinList.first.coinTicker}" : "${coinList[coinSelectIndex].coinTicker}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      fontFamily: 'TextaAlt',),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.black, size: 20,),
                ],
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Amount is required';
            }
            return null;
          },
          onEditingComplete: (){
            startTimer();
            isTimerShow = true;
            setState(() {});
          },
        ),
        SizedBox(height: h * 0.01,),
        Row(
          children: [
            if(isTimerShow)
            Icon(Icons.watch_later_outlined, color: AppColors.greyColor.withOpacity(0.6), size: 20,),
            if(isTimerShow)
            Text(" Refresh in ${start}s",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.greyColor,
                fontFamily: 'TextaAlt',),
            ),
            const Spacer(),
            Text("${coinList[coinSelectIndex].coinTicker} €40,139.81",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.greyColor,
                fontFamily: 'TextaAlt',),
            )
          ],
        ),
        SizedBox(height: h * 0.04,),
        const Row (
          children: [
              Text("Total amount:",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  fontFamily: 'TextaAlt',),
              ),
            Spacer(),
            Text("€0.00",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontFamily: 'TextaAlt',),
            )
          ],
        ),
        SizedBox(height: h * 0.01,),
        InkWell(
          onTap: (){
            setState(() {
              showAllFees = !showAllFees;
            });
          },
          child:  Row (
            children: [
              const Spacer(),
              Text(showAllFees ? 'Hide Fees' : 'All Fees Included' ,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blueColor,
                  fontFamily: 'TextaAlt',
                  decoration: TextDecoration.underline,
                ),
              ),
              Icon(showAllFees ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: AppColors.blueColor, size: 20,),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: showAllFees ? 120.0 : 0.0,
            width: w,
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12,),
                    Row(
                      children: [
                        Center(
                          child: Text(
                            'Payment method',
                            style: TextStyle(color: AppColors.greyColor,fontSize: 18,fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Icon(Icons.info_sharp, color: AppColors.greyColor, size: 20,),
                        Spacer(),
                        Text("€0.00",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyColor,
                            fontFamily: 'TextaAlt',),
                        )
                      ],
                    ),
                    SizedBox(height: 6,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Text(
                            'Network fee',
                            style: TextStyle(color: AppColors.greyColor,fontSize: 18,fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Icon(Icons.info_sharp, color: AppColors.greyColor, size: 20,),
                        Spacer(),
                        Text("€0.00",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyColor,
                            fontFamily: 'TextaAlt',),
                        )
                      ],
                    ),
                    SizedBox(height: 6,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Text(
                            'Total fee',
                            style: TextStyle(color: AppColors.black,fontSize: 18,fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                          ),
                        ),
                        Text("€0.00",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                            fontFamily: 'TextaAlt',),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: showAllFees ? 35.0 : h * 0.18,),*/
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
            indexValue++;
            setState(() {});
          },
        ),
      ],
    );
  }

  coinSelectBottomSheet(BuildContext context) {
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
          height: h * 0.70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(width: w / 2.5),
                  const Text(
                    "Currency",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                  const Spacer(),
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
                ],
              ),
              SizedBox(height: h * 0.01),
              Expanded(
                child: ListView.builder(
                  itemCount: coinList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: w,
                      height: h * 0.08,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.008),
                      decoration: BoxDecoration(
                        color: coinSelectIndex == index ? AppColors.backgroundColor : AppColors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            coinSelectIndex = index;
                            start = 10;
                          });
                          onAmountChanged(value: amount.text, isPay: true);
                          getCurrencyPrice();
                          Navigator.pop(context);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: w * 0.05,
                            ),
                            SvgPicture.network(
                              '${coinList[index].coinIcon}',
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(
                              width: w * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: h * 0.015),
                                Center(
                                  child: Text(
                                    '${coinList[index].coinName}',
                                    style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'TextaAlt',
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${coinList[index].coinTicker}',
                                    style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'TextaAlt',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Icon(
                              coinSelectIndex == index ? Icons.check : Icons.arrow_forward_ios_sharp,
                              color: AppColors.black,
                              size: 15,
                            ),
                            SizedBox(
                              width: w * 0.02,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  paymentMethodBottomSheet(BuildContext context) {
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
          height: h * 0.70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h * 0.01),
              Row(
                children: [
                  SizedBox(width: w / 3.5),
                  const Text(
                    "Payment method",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'TextaAlt',
                    ),
                  ),
                  const Spacer(),
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
                ],
              ),
              SizedBox(height: h * 0.01),
              Expanded(
                child: ListView.builder(
                  itemCount: payMethodList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: w,
                      height: h * 0.08,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.08, vertical: h * 0.004),
                      decoration: BoxDecoration(
                        color: paymentSelectIndex == index ? AppColors.backgroundColor : AppColors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            paymentSelectIndex = index;
                            paymentMethod.text = '${payMethodList[index].label}';
                            Navigator.pop(context);
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: w * 0.04,
                            ),
                            SvgPicture.network(
                              '${payMethodList[index].code}',
                              width: 30,
                              height: 30,
                              fit: BoxFit.fitWidth,
                            ),
                            SizedBox(
                              width: w * 0.04,
                            ),
                            Center(
                              child: Text(
                                '${payMethodList[index].label}',
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'TextaAlt',
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              paymentSelectIndex == index ? Icons.check : null,
                              color: AppColors.black,
                              size: 15,
                            ),
                            SizedBox(
                              width: w * 0.02,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void startTimer() {
    //timer = Timer.periodic(const Duration(seconds: 16), (Timer t) {});
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          // timer.cancel();
          getCurrencyPrice();
          onAmountChanged(value: amount.text, isPay: true);
          start = 10;
          setState(() {});
        } else {
          start--;
          setState(() {});
        }
      },
    );
  }

  getCurrencyPairs() async {
    try {
      isLoading = true;
      List<GetPairsModel> currencyPairs = [];
      http.Response response = await http.get(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/system/currency-pairs"), headers: {"X-Api-Key": xApiKey});
      currencyPairs = List<GetPairsModel>.from(jsonDecode(response.body).map((x) => GetPairsModel.fromJson(x)));
      for (var i = 0; i < currencyPairs.length; i++) {
        coinList.add(CoinModel(
            coinName: currencyPairs[i].currencyPair!.split("-")[0],
            coinTicker: currencyPairs[i].currencyPair!.split("-")[0],
            coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/${currencyPairs[i].currencyPair!.split("-")[0]}.svg"));
        setState(() {});
      }
      getPaymentMethod();
    }
    catch (e) {
      isLoading = false;
      setState(() {});
      log(e.toString());
    }

  }

  getPaymentMethod() async {
    try {
      isLoading = true;
      PaymentMethodModel payMethodPairs;
      http.Response response = await http.get(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/buy/payment-methods"), headers: {"X-Api-Key": xApiKey});
      var tempData = jsonDecode(response.body);
      payMethodPairs = PaymentMethodModel.fromJson(tempData);
      for (var i = 0; i < payMethodPairs.paymentMethods!.length; i++) {
        payMethodList.add(PaymentMethods(
            code: "https://widgets-sandbox.btcdirect.eu/img/payment-methods/${payMethodPairs.paymentMethods![i].code}.svg",
            fee: payMethodPairs.paymentMethods![i].fee,
            limit: payMethodPairs.paymentMethods![i].limit,
            label: payMethodPairs.paymentMethods![i].label,),);
      }
      paymentMethod.text = '${payMethodList.first.label}';
      isLoading = false;
      setState(() {});
    }
    catch (e) {
      isLoading = false;
      setState(() {});
      log(e.toString());
    }

  }

  getCurrencyPrice() async {
    http.Response response = await http.get(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/prices"), headers: {"X-Api-Key": xApiKey});

    var a = jsonDecode(response.body) as Map<String, dynamic>;
    setState(() {
      price = a["buy"]["${coinList[coinSelectIndex].coinTicker}-EUR"];
    });
  }

  onAmountChanged({required String value, required bool isPay}) async {
    Map<String, String> body = isPay
        ? {
            "currencyPair": "${coinList[coinSelectIndex].coinTicker}-EUR",
            "fiatAmount": value.toString(),
            "paymentMethod": "creditCard",
          }
        : {
            "currencyPair": "${coinList[coinSelectIndex].coinTicker}-EUR",
            "cryptoAmount": value.toString(),
            "paymentMethod": "creditCard",
          };
    if(value.isNotEmpty || value != "" || value != "0.0") {
      http.Response response = await http.post(Uri.parse("https://api-sandbox.btcdirect.eu/api/v1/buy/quote"), headers: {"X-Api-Key": xApiKey}, body: body);
      if (!isPay) {
        setState(() {
          amount.text = jsonDecode(response.body)["fiatAmount"].toString() != "null" ? jsonDecode(response.body)["fiatAmount"].toString() : "0.00";
        });
      } else {
        setState(() {
          coinAmount.text = jsonDecode(response.body)["cryptoAmount"].toString() != "null" ? jsonDecode(response.body)["cryptoAmount"].toString() : "0.00";
        });
      }
    }
  }


}

class CoinModel {
  String? coinName;
  String? coinTicker;
  String? coinIcon;

  CoinModel({
    this.coinName,
    this.coinTicker,
    this.coinIcon,
  });
}
