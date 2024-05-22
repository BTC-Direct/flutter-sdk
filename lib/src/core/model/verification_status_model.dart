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

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The returned map contains the following keys:
  /// - 'name': A [String] representing the name of this object.
  /// - 'type': A [String] representing the type of this object.
  /// - 'status': A [String] representing the status of this object.
  /// - 'data': A list of [Data] objects representing the data of this object.
  ///
  /// Returns the JSON [Map] representation of this object.
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

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The returned map contains the following keys:
  /// - 'key': A [String] representing the key of this object.
  /// - 'label': A [String] representing the label of this object.
  /// - 'answers': A list of [String] representing the answers of this object.
  ///
  /// Returns the JSON [Map] representation of this object.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['answers'] = answers;
    return data;
  }
}
