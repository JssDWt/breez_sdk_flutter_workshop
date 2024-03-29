import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class SendPaymentDialog extends StatefulWidget {
  const SendPaymentDialog({super.key});

  @override
  State<SendPaymentDialog> createState() => _SendPaymentDialogState();
}

class _SendPaymentDialogState extends State<SendPaymentDialog> {
  final TextEditingController invoiceController = TextEditingController();
  bool _payInProgress = false;

  @override
  Widget build(BuildContext context) {
    if (_payInProgress) {
      return _payInProgressDialog();
    }

    return AlertDialog(
      title: const Text("Send Payment"),
      content: TextField(
        decoration: const InputDecoration(label: Text("Paste invoice")),
        controller: invoiceController,
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() => _payInProgress = true);
            sdk
                .sendPayment(
                    req: SendPaymentRequest(bolt11: invoiceController.text))
                .then((_) => Navigator.of(context).pop())
                .onError((error, stackTrace) =>
                    debugPrint("ERROR in sendPayment: $error"));
          },
          child: const Text("OK"),
        ),
        TextButton(
          child: const Text("CANCEL"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Widget _payInProgressDialog() {
    return const Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 15,
            ),
            Text('Sending payment...')
          ],
        ),
      ),
    );
  }
}
