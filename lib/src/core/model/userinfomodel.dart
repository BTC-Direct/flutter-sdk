class UserInfoModel {
  String? emailAddress;
  String? firstName;
  String? lastName;
  String? region;
  String? phoneNumber;
  String? registrationDate;
  String? activationDate;
  bool? isBusiness;
  Limits? limits;
  List<String>? enabledIbanAccounts;
  List<String>? enabledWalletAddresses;
  Status? status;

  UserInfoModel(
      {this.emailAddress,
      this.firstName,
      this.lastName,
      this.region,
      this.phoneNumber,
      this.registrationDate,
      this.activationDate,
      this.isBusiness,
      this.limits,
      this.enabledIbanAccounts,
      this.enabledWalletAddresses,
      this.status});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    emailAddress = json['emailAddress'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    region = json['region'];
    phoneNumber = json['phoneNumber'];
    registrationDate = json['registrationDate'];
    activationDate = json['activationDate'];
    isBusiness = json['isBusiness'];
    limits = json['limits'] != null ? Limits.fromJson(json['limits']) : null;
    enabledIbanAccounts = json['enabledIbanAccounts'].cast<String>();
    enabledWalletAddresses = json['enabledWalletAddresses'].cast<String>();
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The [emailAddress], [firstName], [lastName], [region], [phoneNumber],
  /// [registrationDate], [activationDate], [isBusiness], [enabledIbanAccounts],
  /// and [enabledWalletAddresses] properties are converted to their corresponding
  /// JSON representations.
  ///
  /// If the [limits] property is not `null`, it is converted to a JSON
  /// representation by calling the `toJson()` method on it.
  ///
  /// If the [status] property is not `null`, it is converted to a JSON
  /// representation by calling the `toJson()` method on it.
  ///
  /// Returns the JSON representation of this object as a [Map].
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emailAddress'] = emailAddress;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['region'] = region;
    data['phoneNumber'] = phoneNumber;
    data['registrationDate'] = registrationDate;
    data['activationDate'] = activationDate;
    data['isBusiness'] = isBusiness;
    if (limits != null) {
      data['limits'] = limits!.toJson();
    }
    data['enabledIbanAccounts'] = enabledIbanAccounts;
    data['enabledWalletAddresses'] = enabledWalletAddresses;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class Limits {
  Buy? buy;
  Buy? sell;

  Limits({this.buy, this.sell});

  Limits.fromJson(Map<String, dynamic> json) {
    buy = json['buy'] != null ? Buy.fromJson(json['buy']) : null;
    sell = json['sell'] != null ? Buy.fromJson(json['sell']) : null;
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The [buy] property is converted to a JSON representation by calling the
  /// `toJson()` method on it. If [buy] is `null`, the corresponding key-value
  /// pair is not added to the map.
  ///
  /// The [sell] property is converted to a JSON representation by calling the
  /// `toJson()` method on it. If [sell] is `null`, the corresponding key-value
  /// pair is not added to the map.
  ///
  /// Returns:
  ///   A [Map] containing the JSON representation of this object.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (buy != null) {
      data['buy'] = buy!.toJson();
    }
    if (sell != null) {
      data['sell'] = sell!.toJson();
    }
    return data;
  }
}

class Buy {
  Limit? limit;
  Limit? remaining;
  String? interval;

  Buy({this.limit, this.remaining, this.interval});

  Buy.fromJson(Map<String, dynamic> json) {
    limit = json['limit'] != null ? Limit.fromJson(json['limit']) : null;
    remaining =
        json['remaining'] != null ? Limit.fromJson(json['remaining']) : null;
    interval = json['interval'];
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The [limit] property is converted to a JSON representation by calling the
  /// `toJson()` method on it. If [limit] is `null`, the corresponding key-value
  /// pair is not added to the map.
  ///
  /// The [remaining] property is converted to a JSON representation by calling the
  /// `toJson()` method on it. If [remaining] is `null`, the corresponding key-value
  /// pair is not added to the map.
  ///
  /// The [interval] property is added to the map as a key-value pair.
  ///
  /// Returns:
  ///   A [Map] containing the JSON representation of this object.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (limit != null) {
      data['limit'] = limit!.toJson();
    }
    if (remaining != null) {
      data['remaining'] = remaining!.toJson();
    }
    data['interval'] = interval;
    return data;
  }
}

class Limit {
  num? amount;
  String? currencyCode;

  Limit({this.amount, this.currencyCode});

  Limit.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currencyCode = json['currencyCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currencyCode'] = currencyCode;
    return data;
  }
}

class Status {
  String? status;
  String? description;
  Details? details;

  Status({this.status, this.description, this.details});

  Status.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    description = json['description'];
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The [status] property is added to the map as a key-value pair.
  /// The [description] property is added to the map as a key-value pair.
  /// If the [details] property is not `null`, it is converted to a JSON
  /// representation by calling the `toJson()` method on it and added to the map
  /// as a key-value pair.
  ///
  /// Returns the JSON representation of this object as a [Map].
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    return data;
  }
}

class Details {
  String? amld5VerificationStatus;
  String? emailAddressVerificationStatus;
  String? identityVerificationStatus;
  String? privacyAgreementVerificationStatus;
  List<String>? identityDocumentVerificationStatus;

  Details(
      {this.amld5VerificationStatus,
      this.emailAddressVerificationStatus,
      this.identityVerificationStatus,
      this.privacyAgreementVerificationStatus,
      this.identityDocumentVerificationStatus});

  Details.fromJson(Map<String, dynamic> json) {
    amld5VerificationStatus = json['amld5VerificationStatus'];
    emailAddressVerificationStatus = json['emailAddressVerificationStatus'];
    identityVerificationStatus = json['identityVerificationStatus'];
    privacyAgreementVerificationStatus =
        json['privacyAgreementVerificationStatus'];
    identityDocumentVerificationStatus =
        json['identityDocumentVerificationStatus'].cast<String>();
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The returned map contains the following keys:
  /// - 'amld5VerificationStatus': A [String] representing the amld5VerificationStatus of this object.
  /// - 'emailAddressVerificationStatus': A [String] representing the emailAddressVerificationStatus of this object.
  /// - 'identityVerificationStatus': A [String] representing the identityVerificationStatus of this object.
  /// - 'privacyAgreementVerificationStatus': A [String] representing the privacyAgreementVerificationStatus of this object.
  /// - 'identityDocumentVerificationStatus': A [List<String>] representing the identityDocumentVerificationStatus of this object.
  ///
  /// Returns the JSON representation of this object as a [Map].
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amld5VerificationStatus'] = amld5VerificationStatus;
    data['emailAddressVerificationStatus'] = emailAddressVerificationStatus;
    data['identityVerificationStatus'] = identityVerificationStatus;
    data['privacyAgreementVerificationStatus'] =
        privacyAgreementVerificationStatus;
    data['identityDocumentVerificationStatus'] =
        identityDocumentVerificationStatus;
    return data;
  }
}
