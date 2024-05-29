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
  List<EnabledIbanAccounts>? enabledIbanAccounts;
  List<EnabledWalletAddresses>? enabledWalletAddresses;
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
    if (json['enabledIbanAccounts'] != null) {
      enabledIbanAccounts = <EnabledIbanAccounts>[];
      json['enabledIbanAccounts'].forEach((v) {
        enabledIbanAccounts!.add(EnabledIbanAccounts.fromJson(v));
      });
    }
    if (json['enabledWalletAddresses'] != null) {
      enabledWalletAddresses = <EnabledWalletAddresses>[];
      json['enabledWalletAddresses'].forEach((v) {
        enabledWalletAddresses!.add(EnabledWalletAddresses.fromJson(v));
      });
    }
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
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
    if (enabledIbanAccounts != null) {
      data['enabledIbanAccounts'] =
          enabledIbanAccounts!.map((v) => v.toJson()).toList();
    }
    if (enabledWalletAddresses != null) {
      data['enabledWalletAddresses'] =
          enabledWalletAddresses!.map((v) => v.toJson()).toList();
    }
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

class EnabledIbanAccounts {
  String? number;
  String? holder;
  bool? verified;

  EnabledIbanAccounts({this.number, this.holder, this.verified});

  EnabledIbanAccounts.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    holder = json['holder'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['holder'] = holder;
    data['verified'] = verified;
    return data;
  }
}

class EnabledWalletAddresses {
  String? currency;
  String? address;
  String? name;
  String? status;
  String? destinationTag;

  EnabledWalletAddresses(
      {this.currency,
      this.address,
      this.name,
      this.status,
      this.destinationTag});

  EnabledWalletAddresses.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    address = json['address'];
    name = json['name'];
    status = json['status'];
    destinationTag = json['destinationTag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency'] = currency;
    data['address'] = address;
    data['name'] = name;
    data['status'] = status;
    data['destinationTag'] = destinationTag;
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
