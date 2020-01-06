import 'package:flutter/material.dart';

class ExpensesListPage extends StatefulWidget {
  ExpensesListPage({Key key}) : super(key: key);

  @override
  _ExpensesListPageState createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Expenses list'),
    );
  }
}
