import 'package:flutter/material.dart';
import 'package:personal_expenses_app/models/transaction.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';

import 'new_transaction.dart';

class UserTransactions extends StatefulWidget {
  @override
  _UserTransactionsState createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {

  final List<Transaction> _transactions = [
    Transaction
      (
        id: 't1',
        title: 'New Shoes',
        amount: 69.99,
        date: DateTime.now()
    ),
    Transaction
      (
        id: 't2',
        title: 'Grocery Store',
        amount: 19.99,
        date: DateTime.now()
    ),
    Transaction
      (
        id: 't3',
        title: 'Laptop',
        amount: 50.29,
        date: DateTime.now()
    ),
  ];

  void _addNewTransaction(String title, double amount, DateTime chosenDate){
    final newTranscation = Transaction(id: DateTime.now().toString(),title: title, amount: amount, date: DateTime.now());

    setState(() {
      _transactions.add(newTranscation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NewTransaction(_addNewTransaction),

      ],
    );
  }
}
