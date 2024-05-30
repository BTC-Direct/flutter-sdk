import 'dart:developer';

import 'package:btc_direct/src/core/model/verification_status_model.dart';
import 'package:btc_direct/src/presentation/config_packages.dart';
import 'package:http/http.dart' as http;

//ignore: must_be_immutable
class IncomeQuestions extends StatefulWidget {
  VerificationStatusModel incomeQueAndAns;
  String origin;
  String employment;

  IncomeQuestions(
      {required this.incomeQueAndAns,
      required this.origin,
      required this.employment,
      super.key});

  @override
  State<IncomeQuestions> createState() => _IncomeQuestionsState();
}

class _IncomeQuestionsState extends State<IncomeQuestions> {
  int? selectedIndex;
  //bool isLoading = false;
  String question = '';
  List<String> incomeList = <String>[];

  @override
  void initState() {
    super.initState();
    getQuestionsAnswerDataList(context);
  }

  getQuestionsAnswerDataList(BuildContext context) async {
    if (widget.incomeQueAndAns.name == "amld5QuestionAnswers") {
      for (int j = 0; j < widget.incomeQueAndAns.data!.length; j++) {
        if (j == 2) {
          question = widget.incomeQueAndAns.data![j].label.toString();
          var list = widget.incomeQueAndAns.data![j].answers
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')
              .split(',');
          incomeList.addAll(list);
        }
      }
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
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
                      color: CommonColors.blueColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
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
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.08, vertical: h * 0.02),
                child: Text(
                  question,
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
                  itemCount: incomeList.length,
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
                              ? CommonColors.backgroundColor.withOpacity(0.4)
                              : CommonColors.transparent,
                          border: Border.all(
                              color: CommonColors.greyColor, width: 1.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            selectedIndex = index;
                            setState(() {});
                            setQueAnsApiCall(context, incomeList[index]);
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.02, vertical: h * 0.02),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    incomeList[index],
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
          ),
        ),
      ),
    );
  }

  void setQueAnsApiCall(BuildContext context, String selectedIncome) async {
    // setState(() {isLoading = true;});
    try {
      http.Response response = await Repository().setQuestionAnswerApiCall(
        origin: widget.origin,
        employmentStatus: widget.employment,
        income: selectedIncome,
      );
      if (response.statusCode == 202) {
        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const VerifyIdentity(),
              ));
        }
        //setState(() {isLoading = false;});
      } else if (response.statusCode >= 400) {
        var errorCodeList = await AppCommonFunction().getJsonData();
        var tempData = jsonDecode(response.body) as Map<String, dynamic>;
        log("Response ${tempData.toString()}");
        for (int i = 0; i < errorCodeList.length; i++) {
          for (int j = 0; j < tempData['errors'].length; j++) {
            if (errorCodeList[i].code == tempData['errors'].keys.toList()[j]) {
              if (context.mounted) {
                AppCommonFunction().failureSnackBar(
                    context: context, message: '${errorCodeList[i].message}');
              }
            }
          }
        }
      }
      //setState(() {isLoading = false;});
    } catch (e) {
      log(e.toString());
      //setState(() {isLoading = false;});
    }
  }
}
