import 'package:costy/data/models/project.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/utilities/dialog_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExpenseListItem extends StatefulWidget {
  final UserExpense userExpense;
  final Project project;

  ExpenseListItem({Key key, @required this.userExpense, @required this.project})
      : super(key: key);

  @override
  _ExpenseListItemState createState() => _ExpenseListItemState();
}

class _ExpenseListItemState extends State<ExpenseListItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: DialogUtilities.createStackBehindDismiss(context),
      key: ObjectKey(widget.userExpense),
      child: Card(
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Text(widget.userExpense.currency.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
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
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogUtilities.createDeleteConfirmationDialog(context);
          },
        );
      },
      onDismissed: (DismissDirection direction) {
        BlocProvider.of<ExpenseBloc>(context)
            .add(DeleteExpenseEvent(widget.userExpense.id));
        BlocProvider.of<ExpenseBloc>(context)
            .add(GetExpensesEvent(widget.project));
      },
    );
  }
}
