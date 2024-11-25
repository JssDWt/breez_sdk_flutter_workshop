import 'package:flutter/material.dart';

class PaymentsWidget extends StatefulWidget {
  const PaymentsWidget({super.key});

  @override
  State<PaymentsWidget> createState() => _PaymentsWidgetState();
}

class _PaymentsWidgetState extends State<PaymentsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Card(
            key: Key(index.toString()),
            child: ListTile(
              leading: Icon(
                index % 2 == 0 ? Icons.add_rounded : Icons.remove_rounded,
              ),
              title: Text('${index}234 sat'),
              subtitle: Text('fee: $index sat'),
            ),
          );
        });
  }
}
