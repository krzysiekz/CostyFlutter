import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../bloc/bloc.dart';
import '../forms/new_expense_form_page.dart';
import '../item/expense_list_item.dart';
import '../other/page_header.dart';
import '../utilities/dialog_utilities.dart';

class ExpensesListPage extends StatefulWidget {
  final Project project;

  const ExpensesListPage({Key key, @required this.project}) : super(key: key);

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
    return BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
      return PageHeader(
        content: buildBody(),
        buttonOnPressed: () =>
            _handleButtonClick(context, widget.project, state),
        svgAsset: 'assets/images/idea.svg',
        title: AppLocalizations.of(context)
            .translate('project_details_page_expenses'),
        description: AppLocalizations.of(context)
            .translate('expenses_list_page_description'),
        buttonLabel: AppLocalizations.of(context).translate('add'),
      );
    });
  }

  void _showAddExpenseForm(BuildContext ctx, Project project) {
    NewExpenseForm.navigate(ctx, project);
  }

  BlocConsumer<ExpenseBloc, ExpenseState> buildBody() {
    return BlocConsumer<ExpenseBloc, ExpenseState>(
      builder: (BuildContext context, ExpenseState state) {
        if (state is ExpenseEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)
                .translate('expenses_list_page_no_expenses')),
          );
        } else if (state is ExpenseLoaded) {
          if (state.expenses.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)
                  .translate('expenses_list_page_no_expenses')),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemBuilder: (cts, index) {
              return ExpenseListItem(
                key: Key("expense_${state.expenses[index].id}"),
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
              context,
              AppLocalizations.of(context).translate('error'),
              AppLocalizations.of(context)
                  .translate('expenses_list_page_cannot_add'));
        } else if (state is ExpenseAdded) {
          DialogUtilities.showSnackBar(
              context,
              AppLocalizations.of(context)
                  .translate('expenses_list_page_added'));
        } else if (state is ExpenseDeleted) {
          DialogUtilities.showSnackBar(
              context,
              AppLocalizations.of(context)
                  .translate('expenses_list_page_deleted'));
        } else if (state is ExpenseModified) {
          DialogUtilities.showSnackBar(
              context,
              AppLocalizations.of(context)
                  .translate('expenses_list_page_modified'));
        }
      },
    );
  }

  void _handleButtonClick(
      BuildContext context, Project project, UserState state) {
    if (state is UserLoaded && state.users.isNotEmpty) {
      _showAddExpenseForm(context, widget.project);
    } else {
      DialogUtilities.showAlertDialog(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context)
              .translate('expenses_list_page_no_users'));
    }
  }
}
