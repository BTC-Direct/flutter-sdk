class Nationality {
  String? name;
  String? code;
  bool? idSelfieRequired;

  Nationality({this.name, this.code, this.idSelfieRequired});

  Nationality.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    idSelfieRequired = json['idSelfieRequired'];
  }

  /// Converts the object to a JSON [Map].
  ///
  /// Returns a [Map] with the following keys:
  /// - 'name': A [String] representing the name of the object.
  /// - 'code': A [String] representing the code of the object.
  /// - 'idSelfieRequired': A [bool] indicating whether selfie verification is required for the object.
  ///
  /// Returns the JSON [Map] representation of the object.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['idSelfieRequired'] = idSelfieRequired;
    return data;
  }
}
