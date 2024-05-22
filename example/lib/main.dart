import 'package:btc_direct/btc_direct.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "BTC Direct",
          style: TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  /// Navigate to the Buy widget. This widget allows the user to select
                  /// a wallet and complete a buy transaction.
                  ///
                  /// The parameters passed to this widget are:
                  /// - myAddressesList: A list of addresses that the user can select
                  ///   from to complete the transaction.
                  /// - xApiKey: The API key for the BTCDirect API.
                  /// - isSandBox: A boolean that determines whether the transaction is
                  ///   in sandbox mode or production mode.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BTCDirect(
                        myAddressesList: const [
                          {
                            "address": "sender_wallet_address",
                            "currency": "BTC",
                            "id": '1234567',
                            "name": "Sender's Wallet"
                          },
                        ],
                        xApiKey: "your_api_key_here",
                        isSandBox: true,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  elevation: 2.0,
                  textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                child: const Text(
                  'Buy now',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
