import 'package:costy/data/models/user_expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseListItem extends StatefulWidget {
  final UserExpense userExpense;

  ExpenseListItem({Key key, this.userExpense}) : super(key: key);

  @override
  _ExpenseListItemState createState() => _ExpenseListItemState();
}

class _ExpenseListItemState extends State<ExpenseListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: FittedBox(
              child: Column(
                children: <Widget>[
                  Text(widget.userExpense.amount.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(widget.userExpense.currency.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        title: Text(
          widget.userExpense.description,
          style: TextStyle(color: Colors.white70),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(
              color: Theme.of(context).accentColor,
              thickness: 0.8,
            ),
            Text(
              '${widget.userExpense.user.name} => ${widget.userExpense.receivers.map((user) => user.name).toList().join(', ')}',
              style: TextStyle(color: Colors.white70),
            ),
            Divider(
              color: Theme.of(context).accentColor,
              thickness: 0.8,
            ),
            Text(DateFormat.yMMMd().format(widget.userExpense.dateTime),
                style: TextStyle(color: Colors.white70)),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
