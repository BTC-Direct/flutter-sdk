
import 'package:btc_direct/src/presentation/config_packages.dart';

class CompletePayment extends StatefulWidget {
  const CompletePayment({super.key});

  @override
  State<CompletePayment> createState() => _CompletePaymentState();
}

class _CompletePaymentState extends State<CompletePayment> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
      appBarTitle: "Checkout",
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
              completePaymentView(),
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
                fontFamily: 'TextaAlt',package: "btc_direct",
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
                fontFamily: 'TextaAlt',package: "btc_direct",
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
              "Complete",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: CommonColors.blueColor,
                fontFamily: 'TextaAlt',package: "btc_direct",
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
      ],
    );
  }

  completePaymentView() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: h * 0.02,
        ),
        const Text(
          "Coins on the way!",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: CommonColors.black,
            fontFamily: 'TextaAlt',package: "btc_direct",
          ),
        ),
        SizedBox(
          height: h * 0.01,
        ),
        const Text(
          "Hold onto your hat! Coins coming your way in minutes - happy trading!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: CommonColors.black,
            fontFamily: 'TextaAlt',package: "btc_direct",
          ),
        ),
        SizedBox(
          height: h * 0.06,
        ),
        Image.asset(Images.truckIcon, height: 85,width: 85),
        SizedBox(
          height: h * 0.06,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: w * 0.07,
              height: h * 0.06,
              decoration: const BoxDecoration(
                color: CommonColors.blueColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: CommonColors.white, size: 20,),
            ),
            SizedBox(
              width: w * 0.22,
                child: Divider(color: CommonColors.blueColor,thickness: 2,height: h * 0.06,)
            ),
            Container(
              width: w * 0.07,
              height: h * 0.06,
              decoration: const BoxDecoration(
                color: CommonColors.blueColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: CommonColors.white, size: 20,),
            ),
            SizedBox(
                width: w * 0.22,
                child: Divider(color: CommonColors.blueColor,thickness: 2,height: h * 0.06,)
            ),
            Container(
              width: w * 0.07,
              height: h * 0.06,
              decoration: const BoxDecoration(
                color: CommonColors.blueColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: CommonColors.white, size: 20,),
            ),
          ],
        ),
        SizedBox(
          height: h * 0.001,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Order\nconfirmed",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: CommonColors.black,
                fontFamily: 'TextaAlt',package: "btc_direct",
              ),
            ),
            SizedBox(width: w / 8.5,),
            const Text(
              "Payment\ncompleted",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: CommonColors.black,
                fontFamily: 'TextaAlt',package: "btc_direct",
              ),
            ),
            SizedBox(width: w / 8.5,),
            const Text(
              "Coin\ndelivery",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: CommonColors.black,
                fontFamily: 'TextaAlt',package: "btc_direct",
              ),
            ),
          ],
        ),
        SizedBox(
          height: h * 0.06,
        ),
        CommonButtonItem.filled(
          text: "Back to order form",
          fontSize: 20,
          textStyle: const TextStyle(
            fontSize: 22,
            color: CommonColors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'TextaAlt',package: "btc_direct",
          ),
          bgColor: CommonColors.blueColor,
          onPressed: () {
            //Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ]
    );
  }
}
