


import 'dart:async';

import 'package:btcdirect/src/presentation/config_packages.dart';


class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {

  int indexValue = 0;
  TextEditingController amount = TextEditingController();
  TextEditingController coinAmount = TextEditingController();
  int coinSelectIndex = 0;
  late Timer timer;
  int start = 10;
  bool isTimerShow = false;
  bool showAllFees = false;
  List<CoinModel> coinList = [
    CoinModel(coinName: "Bitcoin Cash",coinTicker: "BCH",coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/BCH.svg"),
    CoinModel(coinName: "Bitcoin",coinTicker: "BTC",coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/BTC.svg"),
    CoinModel(coinName: "Ether",coinTicker: "ETH",coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/ETH.svg"),
    CoinModel(coinName: "Litecoin",coinTicker: "LTC",coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/LTC.svg"),
    CoinModel(coinName: "Ripple",coinTicker: "XRP",coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/XRP.svg"),
    CoinModel(coinName: "Tether",coinTicker: "USDT",coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/USDT.svg"),
    CoinModel(coinName: "USD Coin",coinTicker: "USDC",coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/USDC.svg"),
    CoinModel(coinName: "USD Coin",coinTicker: "UNI",coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/UNI.svg"),
    CoinModel(coinName: "USD Coin",coinTicker: "LINK",coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/LINK.svg"),
    CoinModel(coinName: "Algorand",coinTicker: "ALGO",coinIcon: "https://widgets-sandbox.btcdirect.eu/img/currencies/ALGO.svg"),
  ];


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FooterContainer(
        appBarTitle: "Checkout",
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            children: [
              SizedBox(height: h * 0.01,),
              topContainerView(),
              SizedBox(height: h * 0.04,),
              indexValue == 0 ? orderView() : paymentView(),
            ],
          ),
        ),
      );
  }

   topContainerView(){
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
                fontFamily: 'TextaAlt',),
            ),
            SizedBox(height: h * 0.008,),
            Container(
              width:  w / 3.5,
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
                fontFamily: 'TextaAlt',),
            ),
            SizedBox(height: h * 0.008,),
            Container(
              width:  w / 3.5,
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
                fontFamily: 'TextaAlt',),
            ),
            SizedBox(height: h * 0.008,),
            Container(
              width:  w / 3.5,
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

   orderView(){
     double w = MediaQuery.of(context).size.width;
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
            fontFamily: 'TextaAlt',),
        ),
        SizedBox(height: h * 0.01,),
        CommonTextFormField(
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
        SizedBox(height: showAllFees ? 35.0 : h * 0.18,),
        ButtonItem.filled(
          text: "Continue",
          fontSize: 20,
          textStyle: const TextStyle(fontSize: 24,color: AppColors.white,fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
          bgColor: AppColors.blueColor,
          onPressed: () {
            indexValue++;
            setState(() {});
          },
        ),
      ],
    );
   }

  paymentView(){
     double w = MediaQuery.of(context).size.width;
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
            fontFamily: 'TextaAlt',),
        ),
        SizedBox(height: h * 0.01,),
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
          textStyle: const TextStyle(fontSize: 22,color: AppColors.white,fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
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
                  SizedBox(width: w /2.5),
                  const Text("Currency",style: TextStyle(color: AppColors.black, fontSize: 24, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),),
                  const Spacer(),
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
              ),
              SizedBox(height: h * 0.01),
              Expanded(
                child: ListView.builder(
                  itemCount: coinList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: w,
                      height: h * 0.08,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.08,vertical: h * 0.008),
                      decoration: BoxDecoration(
                        color: coinSelectIndex == index ?AppColors.backgroundColor : AppColors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child:  InkWell(
                        onTap: (){
                          setState(() {
                            coinSelectIndex = index;
                          });
                          Navigator.pop(context);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  <Widget>[
                            SizedBox(width: w * 0.05,),
                            SvgPicture.network('${coinList[index].coinIcon}', width: 50, height: 50,),
                            SizedBox(width: w * 0.02,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: h * 0.015),
                                Center(
                                  child: Text(
                                    '${coinList[index].coinName}',
                                    style: const TextStyle(color: AppColors.black, fontSize: 14, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${coinList[index].coinTicker}',
                                    style: const TextStyle(color: AppColors.black, fontSize: 14, fontWeight: FontWeight.w600,fontFamily: 'TextaAlt',),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Icon(coinSelectIndex == index ? Icons.check : Icons.arrow_forward_ios_sharp, color: AppColors.black, size: 15,),
                            SizedBox(width: w * 0.02,),
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
    timer = Timer.periodic(oneSec, (Timer timer) {
        if (start == 0) {
          // timer.cancel();
          start = 10;
          setState(() {});
        } else {
          start--;
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

}


class CoinModel{
  String? coinName;
  String? coinTicker;
  String? coinIcon;

  CoinModel({this.coinName, this.coinTicker, this.coinIcon,});
}


