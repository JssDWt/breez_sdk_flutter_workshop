import 'package:breez_sdk_flutter_workshop/balance.dart';
import 'package:flutter/material.dart';

import 'receive_dialog.dart';
import 'send_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breez SDK Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const BalanceWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ReceivePaymentDialog(),
                      );
                    },
                    child: const Text("RECEIVE"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const SendPaymentDialog(),
                      );
                    },
                    child: const Text("SEND"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
