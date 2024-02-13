class ErrorCodeModel {
  List<ErrorCodeList>? errorCodeList;

  ErrorCodeModel({this.errorCodeList});

  ErrorCodeModel.fromJson(Map<String, dynamic> json) {
    if (json['errorCodeList'] != null) {
      errorCodeList = <ErrorCodeList>[];
      json['errorCodeList'].forEach((v) {
        errorCodeList!.add(ErrorCodeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (errorCodeList != null) {
      data['errorCodeList'] = errorCodeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ErrorCodeList {
  String? code;
  String? message;
  String? solution;

  ErrorCodeList({this.code, this.message, this.solution});

  ErrorCodeList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    solution = json['solution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['solution'] = solution;
    return data;
  }
}
