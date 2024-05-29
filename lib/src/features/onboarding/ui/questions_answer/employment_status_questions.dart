import 'package:btc_direct/src/core/model/verification_status_model.dart';
import 'package:btc_direct/src/presentation/config_packages.dart';

import 'income_questions.dart';

//ignore: must_be_immutable
class EmploymentStatusQuestions extends StatefulWidget {
  VerificationStatusModel employmentQueAndAns;
  String origin;
  EmploymentStatusQuestions(
      {required this.employmentQueAndAns, required this.origin, super.key});

  @override
  State<EmploymentStatusQuestions> createState() =>
      _EmploymentStatusQuestionsState();
}

class _EmploymentStatusQuestionsState extends State<EmploymentStatusQuestions> {
  int? selectedIndex;
  String question = '';
  List<String> employmentList = <String>[];

  @override
  void initState() {
    super.initState();
    getQuestionsAnswerDataList(context);
  }

  getQuestionsAnswerDataList(BuildContext context) async {
    if (widget.employmentQueAndAns.name == "amld5QuestionAnswers") {
      for (int j = 0; j < widget.employmentQueAndAns.data!.length; j++) {
        if (j == 1) {
          question = widget.employmentQueAndAns.data![j].label.toString();
          var list = widget.employmentQueAndAns.data![j].answers
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')
              .split(',');
          employmentList.addAll(list);
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
                  itemCount: employmentList.length,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IncomeQuestions(
                                  incomeQueAndAns: widget.employmentQueAndAns,
                                  origin: widget.origin,
                                  employment: employmentList[index],
                                ),
                              ),
                            );
                            setState(() {});
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.02, vertical: h * 0.02),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    employmentList[index],
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
}
