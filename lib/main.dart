import 'package:bip39/bip39.dart' as bip39;
import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'constants.dart';

const loglevels = ['INFO', 'WARN', 'ERROR'];
final sdk = BreezSDK();
void main() async {
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
  if (!await sdk.isInitialized()) {
    sdk.initialize();
  }
  sdk.logStream.listen((event) {
    if (loglevels.contains(event.level)) {
      // ignore: avoid_print
      print('${event.level}: ${event.line}');
    }
  });

  // Connect
  await sdk.connect(req: ConnectRequest(config: config, seed: seed));
}
