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

  factory WalletAddressModel.fromJson(Map<String, dynamic> json) =>
      WalletAddressModel(
        name: json["name"],
        id: json["id"],
        currency: json["currency"],
        address: json["address"],
      );

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The returned map contains the following keys:
  /// - 'name': A [String] representing the name of this object.
  /// - 'id': A [String] representing the id of this object.
  /// - 'currency': A [String] representing the currency of this object.
  /// - 'address': A [String] representing the address of this object.
  ///
  /// Returns the JSON [Map] representation of this object.
  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "currency": currency,
        "address": address,
      };
}
