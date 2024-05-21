class VerificationStatusModel {
  String? name;
  String? type;
  String? status;
  List<Data>? data;

  VerificationStatusModel({this.name, this.type, this.status, this.data});

  VerificationStatusModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? key;
  String? label;
  List<String>? answers;

  Data({this.key, this.label, this.answers});

  Data.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    answers = json['answers'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['answers'] = answers;
    return data;
  }
}