import 'package:flutter/material.dart';
import 'package:hisab/models/transaction.dart';
import 'package:hisab/widgets/chart.dart';
import 'package:hisab/widgets/newTransaction.dart';
import 'package:hisab/widgets/transaction_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hisab',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          appBarTheme: AppBarTheme(
            titleTextStyle: ThemeData.light()
                .textTheme
                .copyWith(
                  headline6: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .headline6,
          )),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   't1',
    //   'New Shoes',
    //   69.99,
    //   DateTime.now(),
    // ),
    // Transaction(
    //   't2',
    //   'Weekly Groceries',
    //   16.53,
    //   DateTime.now(),
    // )
  ];

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx =
        Transaction(DateTime.now().toString(), txTitle, txAmount, chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<Transaction> _recentTransactions = _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();

    void _startAddNewTransaction(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        },
      );
    }

    void _deleteTransaction(String id) {
      setState(() {
        _userTransactions.removeWhere((tx) => tx.id == id);
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Hisab',
            style: TextStyle(fontFamily: 'Open Sans'),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _startAddNewTransaction(context);
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Chart(_recentTransactions),
                TransactionList(_userTransactions, _deleteTransaction),
              ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _startAddNewTransaction(context);
            },
            child: Icon(Icons.add)));
  }
}
