import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'main.dart';

class ReceivePaymentDialog extends StatefulWidget {
  const ReceivePaymentDialog({super.key});

  @override
  State<ReceivePaymentDialog> createState() => _ReceivePaymentDialogState();
}

class _ReceivePaymentDialogState extends State<ReceivePaymentDialog> {
  String? _invoice;
  String? _paymentHash;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: SizedBox(
            width: 230.0,
            height: 230.0,
            child: _invoice == null
                ? const Center(child: CircularProgressIndicator())
                : QrImageView(data: _invoice!.toUpperCase()),
          ),
        ),
      ),
    );
  }
}
