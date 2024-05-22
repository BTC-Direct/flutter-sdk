class OrderModel {
  int? id;
  String? date;
  String? currencyPair;
  String? status;
  FeeAmount? feeAmount;
  num? feePercentage;
  String? partnerOrderIdentifier;
  List<OrderNotCompletedReasons>? orderNotCompletedReasons;
  FeeAmount? price;
  Value? value;
  String? paymentMethod;
  String? walletAddress;
  String? destinationTag;
  BlockchainInfo? blockchainInfo;
  bool? isDcaOrder;
  bool? isEstimatedQuote;

  OrderModel(
      {this.id,
      this.date,
      this.currencyPair,
      this.status,
      this.feeAmount,
      this.feePercentage,
      this.partnerOrderIdentifier,
      this.orderNotCompletedReasons,
      this.price,
      this.value,
      this.paymentMethod,
      this.walletAddress,
      this.destinationTag,
      this.blockchainInfo,
      this.isDcaOrder,
      this.isEstimatedQuote});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    currencyPair = json['currencyPair'];
    status = json['status'];
    feeAmount = json['feeAmount'] != null
        ? FeeAmount.fromJson(json['feeAmount'])
        : null;
    feePercentage = json['feePercentage'];
    partnerOrderIdentifier = json['partnerOrderIdentifier'];
    if (json['orderNotCompletedReasons'] != null) {
      orderNotCompletedReasons = <OrderNotCompletedReasons>[];
      json['orderNotCompletedReasons'].forEach((v) {
        orderNotCompletedReasons!.add(OrderNotCompletedReasons.fromJson(v));
      });
    }
    price = json['price'] != null ? FeeAmount.fromJson(json['price']) : null;
    value = json['value'] != null ? Value.fromJson(json['value']) : null;
    paymentMethod = json['paymentMethod'];
    walletAddress = json['walletAddress'];
    destinationTag = json['destinationTag'];
    blockchainInfo = json['blockchainInfo'] != null
        ? BlockchainInfo.fromJson(json['blockchainInfo'])
        : null;
    isDcaOrder = json['isDcaOrder'];
    isEstimatedQuote = json['isEstimatedQuote'];
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The [feeAmount] property is converted to a JSON representation by calling
  /// the `toJson()` method on it. If [feeAmount] is `null`, the corresponding
  /// key-value pair is not added to the map.
  ///
  /// The [orderNotCompletedReasons] property is converted to a list of JSON
  /// representations by calling the `toJson()` method on each element of the
  /// list. If [orderNotCompletedReasons] is `null`, the corresponding key-value
  /// pair is not added to the map.
  ///
  /// The [price] property is converted to a JSON representation by calling the
  /// `toJson()` method on it. If [price] is `null`, the corresponding key-value
  /// pair is not added to the map.
  ///
  /// The [value] property is converted to a JSON representation by calling the
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['currencyPair'] = currencyPair;
    data['status'] = status;
    if (feeAmount != null) {
      data['feeAmount'] = feeAmount!.toJson();
    }
    data['feePercentage'] = feePercentage;
    data['partnerOrderIdentifier'] = partnerOrderIdentifier;
    if (orderNotCompletedReasons != null) {
      data['orderNotCompletedReasons'] =
          orderNotCompletedReasons!.map((v) => v.toJson()).toList();
    }
    if (price != null) {
      data['price'] = price!.toJson();
    }
    if (value != null) {
      data['value'] = value!.toJson();
    }
    data['paymentMethod'] = paymentMethod;
    data['walletAddress'] = walletAddress;
    data['destinationTag'] = destinationTag;
    if (blockchainInfo != null) {
      data['blockchainInfo'] = blockchainInfo!.toJson();
    }
    data['isDcaOrder'] = isDcaOrder;
    data['isEstimatedQuote'] = isEstimatedQuote;
    return data;
  }
}

class FeeAmount {
  num? amount;
  String? currencyCode;

  FeeAmount({this.amount, this.currencyCode});

  FeeAmount.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currencyCode = json['currencyCode'];
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The [amount] property is converted to a JSON representation by calling
  /// the `toJson()` method on it. If [amount] is `null`, the corresponding
  /// key-value pair is not added to the map.
  ///
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currencyCode'] = currencyCode;
    return data;
  }
}

class OrderNotCompletedReasons {
  String? code;
  String? description;
  String? solution;
  bool? userActionRequired;
  bool? supportActionRequired;
  String? url;

  OrderNotCompletedReasons(
      {this.code,
      this.description,
      this.solution,
      this.userActionRequired,
      this.supportActionRequired,
      this.url});

  OrderNotCompletedReasons.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    solution = json['solution'];
    userActionRequired = json['userActionRequired'];
    supportActionRequired = json['supportActionRequired'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = description;
    data['solution'] = solution;
    data['userActionRequired'] = userActionRequired;
    data['supportActionRequired'] = supportActionRequired;
    data['url'] = url;
    return data;
  }
}

class Value {
  num? amount;
  String? currencyCode;

  Value({this.amount, this.currencyCode});

  Value.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currencyCode = json['currencyCode'];
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The [amount] property is converted to a JSON representation by calling
  /// the `toJson()` method on it. If [amount] is `null`, the corresponding
  /// key-value pair is not added to the map.

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currencyCode'] = currencyCode;
    return data;
  }
}

class BlockchainInfo {
  String? walletAddress;
  String? walletExplorer;
  String? transactionId;
  String? transactionExplorer;

  BlockchainInfo(
      {this.walletAddress,
      this.walletExplorer,
      this.transactionId,
      this.transactionExplorer});

  BlockchainInfo.fromJson(Map<String, dynamic> json) {
    walletAddress = json['walletAddress'];
    walletExplorer = json['walletExplorer'];
    transactionId = json['transactionId'];
    transactionExplorer = json['transactionExplorer'];
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The [walletAddress] property is converted to a JSON representation by
  /// calling the `toJson()` method on it. If [walletAddress] is `null`,
  /// the corresponding key-value pair is not added to the map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['walletAddress'] = walletAddress;
    data['walletExplorer'] = walletExplorer;
    data['transactionId'] = transactionId;
    data['transactionExplorer'] = transactionExplorer;
    return data;
  }
}
