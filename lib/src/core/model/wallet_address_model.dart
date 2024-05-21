class WalletAddressModel {
  final String address;
  final String currency;
  final String id;
  final String name;
  WalletAddressModel({
    required this.name,
    required this.id,
    required this.currency,
    required this.address,
  });

  factory WalletAddressModel.fromJson(Map<String, dynamic> json) => WalletAddressModel(
    name: json["name"],
    id: json["id"],
    currency: json["currency"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "currency": currency,
    "address": address,
  };
}