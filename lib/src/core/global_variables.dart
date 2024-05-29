import 'package:btc_direct/src/presentation/config_packages.dart';

///A boolean flag designating whether the procedure ought to execute in a Sandbox setting.
/// For testing purposes, set to true; in production environments, set to false.
bool isSandBox = false;

///The API key required for authentication or authorization.
String xApiKey = "";

///You can choose to receive all payment methods per country, or only the preferred ones for each country.
///Available values : all, preferred
///
/// Default value : all
String paymentMethods = 'all';

///A list containing information about the sender's wallet address.
/// "address": The sender's wallet address.
///  "currency": The currency in which the transaction will be made.
///  "id": An identifier for the wallet address.
///  "name": A name for the sender's wallet.
List<WalletAddressModel> addressesList = [];
