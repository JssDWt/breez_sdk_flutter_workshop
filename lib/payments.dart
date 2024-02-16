import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class PaymentsWidget extends StatefulWidget {
  const PaymentsWidget({super.key});

  @override
  State<PaymentsWidget> createState() => _PaymentsWidgetState();
}

class _PaymentsWidgetState extends State<PaymentsWidget> {
  List<Payment> _payments = [];

  @override
  void initState() {
    super.initState();
    sdk.nodeStateStream.listen((event) {
      if (event == null) return;
      sdk
          .listPayments(req: const ListPaymentsRequest())
          .then((value) => setState(() => _payments = value))
          .catchError((e) {
        print('error getting payments: $e');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _payments.length,
        itemBuilder: (context, index) {
          final payment = _payments[index];
          final data = payment.details.data as LnPaymentDetails;
          return Card(
            key: Key(data.paymentHash),
            child: ListTile(
              leading: Icon(
                payment.paymentType == PaymentType.Received
                    ? Icons.add_rounded
                    : Icons.remove_rounded,
              ),
              title: Text('${payment.amountMsat ~/ 1000} sat'),
              subtitle: Text('fee: ${payment.feeMsat ~/ 1000} sat'),
            ),
          );
        });
  }
}
