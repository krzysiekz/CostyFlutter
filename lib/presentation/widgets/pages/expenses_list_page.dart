import 'package:costy/presentation/widgets/item/expense_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/project.dart';
import '../../bloc/bloc.dart';
import '../utilities/dialog_utilities.dart';

class ExpensesListPage extends StatefulWidget {
  final Project project;

  ExpensesListPage({Key key, @required this.project}) : super(key: key);

  @override
  _ExpensesListPageState createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  @override
  void initState() {
    BlocProvider.of<ExpenseBloc>(context).add(GetExpensesEvent(widget.project));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseBloc, ExpenseState>(
      bloc: BlocProvider.of<ExpenseBloc>(context),
      builder: (BuildContext context, ExpenseState state) {
        if (state is ExpenseEmpty) {
          return const Text("No expenses to display.");
        } else if (state is ExpenseLoaded) {
          if (state.expenses.isEmpty) {
            return const Text("No expenses to display.");
          }
          return ListView.builder(
            padding: const EdgeInsets.all(25),
            itemBuilder: (cts, index) {
              return ExpenseListItem(
                userExpense: state.expenses[index],
                project: widget.project,
              );
            },
            itemCount: state.expenses.length,
          );
        } else if (state is UserLoading) {
          return DialogUtilities.showLoadingIndicator(context);
        }
        return Container();
      },
      listener: (BuildContext context, ExpenseState state) {
        if (state is ExpenseError) {
          DialogUtilities.showAlertDialog(
              context, 'Error', 'Cannot add expense');
        } else if (state is ExpenseAdded) {
          DialogUtilities.showSnackBar(context, 'Expense added.');
        } else if (state is ExpenseDeleted) {
          DialogUtilities.showSnackBar(context, 'Expense deleted.');
        } else if (state is ExpenseModified) {
          DialogUtilities.showSnackBar(context, 'Expense modified.');
        }
      },
    );
  }
}
