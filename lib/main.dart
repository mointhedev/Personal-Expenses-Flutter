import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transaction.dart';
import 'package:personal_expenses_app/widgets/chart.dart';
import 'package:personal_expenses_app/widgets/new_transaction.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';
import 'package:personal_expenses_app/widgets/user_transactions.dart';

void main() {
//  SystemChrome.setPreferredOrientations(
//      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          errorColor: Colors.redAccent,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
//    Transaction(
//        id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
//    Transaction(
//        id: 't2', title: 'Grocery Store', amount: 19.99, date: DateTime.now()),
//    Transaction(id: 't3', title: 'Laptop', amount: 50.29, date: DateTime.now()),
  ];

  bool _showChart = true;

  List<Transaction> get _recentTransactions {
    return _transactions.where((transactions) {
      return transactions.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTranscation = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: chosenDate == null ? DateTime.now() : chosenDate);

    setState(() {
      _transactions.add(newTranscation);
    });
  }

//
//  String titleInput;
//  String amountInput;

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) {
        return transaction.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    PreferredSizeWidget buildAppBar() {
      return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text("Personal Expenses"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text("Personal Expenses"),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                ),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
    }

    final TransListWidget = Container(
      child: TransactionList(_transactions, _deleteTransaction),
      height: (mediaQuery.size.height -
              buildAppBar().preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
    );

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Show Chart: "),
                Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    })
              ],
            ),
          //_showChart == false ? null :
          if (isLandscape)
            _showChart
                ? Container(
                    child: Chart(
                      _recentTransactions,
                    ),
                    height: (mediaQuery.size.height -
                            buildAppBar().preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                  )
                : TransListWidget,
          if (!isLandscape)
            Container(
              child: Chart(
                _recentTransactions,
              ),
              height: (mediaQuery.size.height -
                      buildAppBar().preferredSize.height -
                      mediaQuery.padding.top) *
                  0.3,
            ),
          if (!isLandscape)
            TransListWidget,
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar:buildAppBar(),
            child: pageBody,
          )
        : Scaffold(
            appBar: buildAppBar(),
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
