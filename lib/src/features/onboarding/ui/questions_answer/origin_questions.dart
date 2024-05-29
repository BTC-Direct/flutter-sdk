import 'dart:developer';

import 'package:btc_direct/src/core/model/verification_status_model.dart';
import 'package:btc_direct/src/features/onboarding/ui/questions_answer/employment_status_questions.dart';
import 'package:btc_direct/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;

import '../../../../../btc_direct.dart';

class OriginQuestions extends StatefulWidget {
  const OriginQuestions({super.key});

  @override
  State<OriginQuestions> createState() => _OriginQuestionsState();
}

class _OriginQuestionsState extends State<OriginQuestions> {
  int? selectedIndex;
  List<String> originList = [];
  String question = '';
  bool isQuestionShow = false;
  late VerificationStatusModel verificationStatusModel;

  @override
  void initState() {
    super.initState();
    getQuestionsAnswerDataList(context);
  }

  /// Retrieves the KYC access token from the server.
  getQuestionsAnswerDataList(BuildContext context) async {
    try {
      http.Response response =
          await Repository().getVerificationStatusApiCall(context);
      var tempData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (tempData == null || tempData.length == [] || tempData.isEmpty) {
          var list = await StorageHelper.getValue(StorageKeys.myAddressesList);
          final List<Map<String, dynamic>> jsonList = jsonDecode(list);
          var xApiKey = await StorageHelper.getValue(StorageKeys.xApiKey);
          var isSandBox = await StorageHelper.getValue(StorageKeys.isSandBox);
          if (context.mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BTCDirect(
                    myAddressesList: jsonList,
                    xApiKey: xApiKey,
                    isSandBox: isSandBox,
                  ),
                ));
          }
        } else {
          for (int i = 0; i < tempData.length; i++) {
            if (tempData[i]['name'] == "amld5QuestionAnswers") {
              if (tempData[i]['status'] == 'open' ||
                  tempData[i]['status'] == 'missing' ||
                  tempData[i]['status'] == 'pending') {
                verificationStatusModel =
                    VerificationStatusModel.fromJson(tempData[i]);
                if (verificationStatusModel.name == "amld5QuestionAnswers") {
                  for (int j = 0;
                      j < verificationStatusModel.data!.length;
                      j++) {
                    if (j == 0) {
                      question =
                          verificationStatusModel.data![j].label.toString();
                      var list = verificationStatusModel.data![j].answers
                          .toString()
                          .replaceAll('[', '')
                          .replaceAll(']', '')
                          .split(',');
                      originList.addAll(list);
                    }
                  }
                }
              }
              break;
            }
          }
        }
      } else if (response.statusCode >= 400) {
        log("Response ${tempData.toString()}");
        var errorCodeList = await AppCommonFunction().getJsonData();
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
              log(errorCodeList[i].message);
            }
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return CommonFontDimen(
      child: FooterContainer(
        isAppBarLeadShow: true,
        appBarTitle: "Questions",
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: isQuestionShow
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: w / 3.5,
                            height: h * 0.007,
                            decoration: BoxDecoration(
                              color: CommonColors.blueColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Container(
                            width: w / 3.5,
                            height: h * 0.007,
                            decoration: BoxDecoration(
                              color: CommonColors.greyColor.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Container(
                            width: w / 3.5,
                            height: h * 0.007,
                            decoration: BoxDecoration(
                              color: CommonColors.greyColor.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: w * 0.08, vertical: h * 0.02),
                        child: Text(
                          question,
                          //'What is the origin of the funds you invest?',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: CommonColors.black,
                            fontFamily: 'TextaAlt',
                            package: 'btc_direct',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      ListView.builder(
                          itemCount: originList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: h * 0.01),
                              child: Container(
                                width: w / 1.5,
                                height: h * 0.07,
                                decoration: BoxDecoration(
                                  color: selectedIndex == index
                                      ? CommonColors.backgroundColor
                                          .withOpacity(0.4)
                                      : CommonColors.transparent,
                                  border: Border.all(
                                      color: CommonColors.greyColor,
                                      width: 1.2),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    selectedIndex = index;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EmploymentStatusQuestions(
                                          employmentQueAndAns:
                                              verificationStatusModel,
                                          origin: originList[index],
                                        ),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: w * 0.02,
                                          vertical: h * 0.02),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            originList[index],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: CommonColors.black,
                                              fontFamily: 'TextaAlt',
                                              package: 'btc_direct',
                                            ),
                                          ),
                                          Icon(
                                            selectedIndex == index
                                                ? Icons.check
                                                : Icons.arrow_forward_ios_sharp,
                                            color: CommonColors.black,
                                            size: 15,
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            );
                          })
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: h * 0.03,
                      ),
                      Center(
                          child: Image.asset(
                        Images.locker,
                        height: h * 0.2,
                        fit: BoxFit.fill,
                      )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 0.08,
                        ),
                        child: const Text(
                          'Start safe and secure',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: CommonColors.black,
                            fontFamily: 'TextaAlt',
                            package: 'btc_direct',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: w * 0.08, vertical: h * 0.01),
                        child: const Text(
                          'To help you as best as possible we would like to ask you a few short questions.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: CommonColors.greyColor,
                            fontFamily: 'TextaAlt',
                            package: 'btc_direct',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      CommonButtonItem.filled(
                        text: "Answer questions",
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: CommonColors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'TextaAlt',
                        ),
                        bgColor: CommonColors.blueColor,
                        onPressed: () {
                          isQuestionShow = true;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
