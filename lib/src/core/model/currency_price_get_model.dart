class CurrencyPriceGetModel {
  String? currencyPair;
  BaseCurrency? baseCurrency;
  BaseCurrency? quoteCurrency;
  Buy? buy;
  Sell? sell;

  CurrencyPriceGetModel(
      {this.currencyPair,
      this.baseCurrency,
      this.quoteCurrency,
      this.buy,
      this.sell});

  CurrencyPriceGetModel.fromJson(Map<String, dynamic> json) {
    currencyPair = json['currencyPair'];
    baseCurrency = json['baseCurrency'] != null
        ? BaseCurrency.fromJson(json['baseCurrency'])
        : null;
    quoteCurrency = json['quoteCurrency'] != null
        ? BaseCurrency.fromJson(json['quoteCurrency'])
        : null;
    buy = json['buy'] != null ? Buy.fromJson(json['buy']) : null;
    sell = json['sell'] != null ? Sell.fromJson(json['sell']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currencyPair'] = currencyPair;
    if (baseCurrency != null) {
      data['baseCurrency'] = baseCurrency!.toJson();
    }
    if (quoteCurrency != null) {
      data['quoteCurrency'] = quoteCurrency!.toJson();
    }
    if (buy != null) {
      data['buy'] = buy!.toJson();
    }
    if (sell != null) {
      data['sell'] = sell!.toJson();
    }
    return data;
  }
}

class BaseCurrency {
  String? code;
  String? name;
  num? decimals;

  BaseCurrency({this.code, this.name, this.decimals});

  BaseCurrency.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    decimals = json['decimals'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['decimals'] = decimals;
    return data;
  }
}

class Buy {
  String? status;
  Min? min;
  Min? max;

  Buy({this.status, this.min, this.max});

  Buy.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    min = json['min'] != null ? Min.fromJson(json['min']) : null;
    max = json['max'] != null ? Min.fromJson(json['max']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (min != null) {
      data['min'] = min!.toJson();
    }
    if (max != null) {
      data['max'] = max!.toJson();
    }
    return data;
  }
}

class Min {
  num? amount;
  String? currencyCode;

  Min({this.amount, this.currencyCode});

  Min.fromJson(Map<String, dynamic> json) {
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

class Sell {
  String? status;
  Min? min;
  Min? max;
  Address? address;

  Sell({this.status, this.min, this.max, this.address});

  Sell.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    min = json['min'] != null ? Min.fromJson(json['min']) : null;
    max = json['max'] != null ? Min.fromJson(json['max']) : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (min != null) {
      data['min'] = min!.toJson();
    }
    if (max != null) {
      data['max'] = max!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Address {
  String? address;
  String? destinationTag;

  Address({this.address, this.destinationTag});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    destinationTag = json['destinationTag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['destinationTag'] = destinationTag;
    return data;
  }
}
