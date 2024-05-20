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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['idSelfieRequired'] = idSelfieRequired;
    return data;
  }
}
