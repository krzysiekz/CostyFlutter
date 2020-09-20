import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../../keys.dart';
import '../../../style_constants.dart';
import '../../bloc/bloc.dart';
import '../forms/new_expense_form_page.dart';
import '../item/expense_list_item.dart';
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
    return Column(
      children: [
        ClipRect(child: buildHeader(context)),
        Expanded(child: buildBody()),
      ],
    );
  }

  Stack buildHeader(BuildContext context) {
    return Stack(
      children: [
        buildHeaderBackground(),
        buildHeaderDescription(context),
      ],
    );
  }

  Transform buildHeaderBackground() {
    return Transform.translate(
      offset: const Offset(0, -80),
      child: Transform.scale(
        scale: 1.2,
        child: Stack(
          children: [
            buildBottomCard(),
            buildTopCard(),
          ],
        ),
      ),
    );
  }

  Transform buildTopCard() {
    return Transform.translate(
      offset: const Offset(30, 0),
      child: Transform.rotate(
        angle: -15 * pi / 180,
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                gradient: StyleConstants.primaryGradient),
          ),
          Positioned(
            bottom: -20,
            child: Transform.scale(
              scale: 0.8,
              child: SvgPicture.asset('assets/images/idea.svg',
                  semanticsLabel: 'Expenses image'),
            ),
          )
        ]),
      ),
    );
  }

  Transform buildBottomCard() {
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            gradient: StyleConstants.secondaryGradient),
      ),
    );
  }

  Padding buildHeaderDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 40),
      child: Wrap(
        direction: Axis.vertical,
        spacing: 15,
        children: [
          Text(
              AppLocalizations.of(context)
                  .translate('project_details_page_expenses'),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: StyleConstants.primaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.primaryTextSize,
              )),
          Text(
              AppLocalizations.of(context)
                  .translate('expenses_list_page_description'),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: StyleConstants.secondaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.secondaryTextSize,
              )),
          BlocBuilder<UserBloc, UserState>(
              builder: (BuildContext context, UserState state) {
            if (state is UserLoaded && state.users.isNotEmpty) {
              return buildAddUserButton(
                  context, () => _showAddExpenseForm(context, widget.project));
            } else {
              return buildAddUserButton(
                  context,
                  () => DialogUtilities.showAlertDialog(
                      context,
                      AppLocalizations.of(context).translate('info'),
                      AppLocalizations.of(context)
                          .translate('expenses_list_page_no_users')));
            }
          }),
        ],
      ),
    );
  }

  FlatButton buildAddUserButton(BuildContext context, VoidCallback callback) {
    return FlatButton(
      key: const Key(Keys.projectDetailsAddExpenseButton),
      onPressed: callback,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
      ),
      color: Colors.white,
      child: Text(AppLocalizations.of(context).translate('add'),
          style: const TextStyle(
            fontWeight: StyleConstants.buttonsTextFontWeight,
            color: Colors.black,
            fontSize: StyleConstants.buttonsTextSize,
          )),
    );
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
}
