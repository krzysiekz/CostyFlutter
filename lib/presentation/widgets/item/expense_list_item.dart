import 'dart:math';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../../data/models/user_expense.dart';
import '../../../style_constants.dart';
import '../../bloc/bloc.dart';
import '../forms/new_expense_form_page.dart';
import '../utilities/dialog_utilities.dart';

class ExpenseListItem extends StatefulWidget {
  static final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");

  final UserExpense userExpense;
  final Project project;

  const ExpenseListItem(
      {Key key, @required this.userExpense, @required this.project})
      : super(key: key);

  @override
  _ExpenseListItemState createState() => _ExpenseListItemState();
}

class _ExpenseListItemState extends State<ExpenseListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
      child: Stack(
        children: [
          buildBottomCard(),
          buildTopCard(),
          Positioned.fill(
            child: Row(
              children: [
                Expanded(flex: 2, child: buildAmountSection()),
                Expanded(flex: 5, child: buildDescriptionSection()),
                buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildTopCard() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: StyleConstants.secondaryGradient),
    );
  }

  Transform buildBottomCard() {
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: StyleConstants.primaryGradient),
      ),
    );
  }

  Widget buildAmountSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(widget.userExpense.amount.toStringAsFixed(2),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: StyleConstants.primaryFontWeight,
                  color: StyleConstants.primaryTextColor,
                  fontSize: StyleConstants.secondaryTextSize,
                )),
          ),
          Text(widget.userExpense.currency.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: StyleConstants.primaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.secondaryTextSize,
              ))
        ],
      ),
    );
  }

  Widget buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(widget.userExpense.description,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontWeight: StyleConstants.primaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.secondaryTextSize,
              )),
          const SizedBox(
            height: 8,
          ),
          Text(ExpenseListItem.dateFormat.format(widget.userExpense.dateTime),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: StyleConstants.secondaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.descriptionTextSize,
              )),
          const SizedBox(
            height: 8,
          ),
          RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: StyleConstants.descriptionTextSize,
                color: StyleConstants.primaryTextColor,
                fontWeight: StyleConstants.secondaryFontWeight,
              ),
              children: [
                TextSpan(
                    text: widget.userExpense.user.name,
                    style: const TextStyle(
                      fontWeight: StyleConstants.primaryFontWeight,
                    )),
                TextSpan(
                  text: AppLocalizations.of(context)
                      .translate('expenses_item_paid_description'),
                ),
                TextSpan(
                  text: widget.userExpense.receivers
                      .map((user) => user.name)
                      .toList()
                      .join(', '),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [buildDeleteButton(context), buildEditButton(context)],
      ),
    );
  }

  Widget buildEditButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              FeatherIcons.edit3,
              color: StyleConstants.primaryColor,
            ),
          ),
          onPressed: () => _showAddExpenseForm(context, widget.project)),
    );
  }

  Widget buildDeleteButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              FeatherIcons.trash2,
              color: Colors.red,
            ),
          ),
          onPressed: () async {
            final bool result = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return DialogUtilities.createDeleteConfirmationDialog(
                      context);
                });
            if (result) {
              BlocProvider.of<ExpenseBloc>(context)
                  .add(DeleteExpenseEvent(widget.userExpense.id));
              BlocProvider.of<ExpenseBloc>(context)
                  .add(GetExpensesEvent(widget.project));
            }
          }),
    );
  }

  void _showAddExpenseForm(BuildContext ctx, Project project) {
    NewExpenseForm.navigate(ctx, project, expenseToEdit: widget.userExpense);
  }
}
