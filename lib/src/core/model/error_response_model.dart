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

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The [errorCodeList] property is converted to a list of JSON representations
  /// by calling the `toJson()` method on each element of the list. If
  /// [errorCodeList] is `null`, the corresponding key-value pair is not added
  /// to the map.
  ///
  /// Returns:
  ///   A [Map] containing the JSON representation of this object.
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
