# breez_sdk_flutter_workshop

This workshop demonstrates how to integrate lightning payments into a Flutter
application. The workshop starts with a UI with some dialogs. Step by step we
take you through integrating lightning payments.
- Setup a node
- Receive a payment
- Send a payment
- Show the balance

In order to give this workshop, look at the commits. Each commit is a step in
the workshop process. You either paste in the code, or go to the next commit.
At each step, explain what the new code is doing.

## Prerequisites
- Flutter 3.7.12 installed
- Have the source for breez SDK next to this repository (../breez-sdk), compiled
  and ready.
- Android studio installed
- A fresh Android emulator (API 30, x86) running.
- A valid greenlight invite code and breez api key set in `lib/constants.dart`

## Steps

### Add Breez SDK dependency
In `pubspec.yaml`, under `dependencies:`
```yaml
  breez_sdk:
    git: 
      url: https://github.com/breez/breez-sdk-flutter.git
      ref: 0.2.14
```

### Setup a node
Replace the contents of main.dart:
```dart
import 'package:breez_sdk/breez_sdk.dart';
import 'package:logging/logging.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bip39/bip39.dart' as bip39;

import 'app.dart';
import 'constants.dart';

final sdk = BreezSDK();

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  _startSdk();
  runApp(const App());
}

Future _startSdk() async {
  // Get or generate the seed
  const secureStorage = FlutterSecureStorage();
  var mnemonic = await secureStorage.read(key: "mnemonic");
  if (mnemonic == null) {
    mnemonic = bip39.generateMnemonic();
    secureStorage.write(key: "mnemonic", value: mnemonic);
  }
  final seed = bip39.mnemonicToSeed(mnemonic);

  // Create configuration
  final workingDir = (await getApplicationDocumentsDirectory()).path;
  var config = await sdk.defaultConfig(
    envType: EnvironmentType.Production,
    apiKey: breezLspApiKey,
    nodeConfig: NodeConfig.greenlight(
      config: GreenlightNodeConfig(inviteCode: greenlightInviteCode),
    ),
  );
  config = config.copyWith(workingDir: workingDir);

  // Initialize flutter specific listeners and logs.
  sdk.initialize();

  // Connect
  await sdk.connect(config: config, seed: seed);
}

```

### Receive a payment
In `receive_dialog.dart`, `ReceivePaymentDialog.initState`:
```dart
    sdk.invoicePaidStream.listen((event) {
      if (event.paymentHash == _paymentHash) {
        Navigator.of(context).pop();
      }
    });

    sdk
        .receivePayment(
          req: const ReceivePaymentRequest(
            amountMsat: 10000000,
            description: "My first Breez SDK invoice",
          ),
        )
        .then(
          (value) => setState(
            () {
              _invoice = value.lnInvoice.bolt11;
              _paymentHash = value.lnInvoice.paymentHash;
            },
          ),
        )
        .onError(
          (error, stackTrace) => debugPrint("ERROR in receivePayment: $error"),
        );
```

### Send a payment
In `send_dialog.dart` `SendPaymentDialog`, contents of `onPressed`
```dart
            setState(() => _payInProgress = true);
            sdk
                .sendPayment(
                    req: SendPaymentRequest(bolt11: invoiceController.text))
                .then((_) => Navigator.of(context).pop())
                .onError((error, stackTrace) =>
                    debugPrint("ERROR in sendPayment: $error"));
```

### Update balance
In `balance.dart`
```dart
  @override
  void initState() {
    super.initState();
    sdk.nodeStateStream.listen((event) {
      if (event == null) return;
      setState(() => _balance = event.maxPayableMsat ~/ 1000);
    });
  }
```