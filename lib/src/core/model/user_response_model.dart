class UserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? country;
  bool? isBusiness;
  String? registrationDate;
  String? activationDate;

  UserModel(
      {this.email,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.country,
      this.isBusiness,
      this.registrationDate,
      this.activationDate});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    country = json['country'];
    isBusiness = json['isBusiness'];
    registrationDate = json['registrationDate'];
    activationDate = json['activationDate'];
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['country'] = country;
    data['isBusiness'] = isBusiness;
    data['registrationDate'] = registrationDate;
    data['activationDate'] = activationDate;
    return data;
  }
}
