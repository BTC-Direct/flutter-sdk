class OrderModel {
  int? id;
  String? date;
  String? currencyPair;
  String? status;
  FeeAmount? feeAmount;
  double? feePercentage;
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
    price =
    json['price'] != null ? FeeAmount.fromJson(json['price']) : null;
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
  int? amount;
  String? currencyCode;

  FeeAmount({this.amount, this.currencyCode});

  FeeAmount.fromJson(Map<String, dynamic> json) {
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
  double? amount;
  String? currencyCode;

  Value({this.amount, this.currencyCode});

  Value.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['walletAddress'] = walletAddress;
    data['walletExplorer'] = walletExplorer;
    data['transactionId'] = transactionId;
    data['transactionExplorer'] = transactionExplorer;
    return data;
  }
}