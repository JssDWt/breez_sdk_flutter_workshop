import 'package:flutter/material.dart';

class BalanceWidget extends StatefulWidget {
  const BalanceWidget({super.key});

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  int _balance = -1;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_balance sat',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
