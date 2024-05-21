# BTC Direct

## IMPORTANT
* `myAddressesList`: A list containing information about the sender's wallet address.
* `address`: The sender's wallet address.
* `currency`: The currency in which the transaction will be made.
* `id`: An identifier for the wallet address.
* `name`: A name for the sender's wallet.
* `xApiKey`: The API key required for authentication or authorization.
* `isSandBox`: A boolean flag indicating whether the method should operate in a sandbox environment. Set to true for testing    purposes, and false for production environments.

## Example
```dart
BTCDirect(
  myAddressesList: [
    {
      "address": "sender_wallet_address", "currency": "BTC",
      "id": '1',
      "name": "Sender's Wallet"
    },
  ],
  xApiKey: "your_api_key_here",
  isSandBox:true,
);
```
## Note
Ensure that the `xApiKey` provided is valid and has the necessary permissions for executing Bitcoin transactions.
