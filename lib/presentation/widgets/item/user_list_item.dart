import 'dart:math';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../../data/models/user.dart';
import '../../../style_constants.dart';
import '../../bloc/bloc.dart';
import '../forms/new_user_form_page.dart';
import '../utilities/dialog_utilities.dart';

class UserListItem extends StatefulWidget {
  final User user;
  final Project project;

  const UserListItem({Key key, @required this.user, @required this.project})
      : super(key: key);

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          buildBottomCard(),
          buildTopCard(),
          Container(
            height: 70,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Text(widget.user.name,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: const TextStyle(
                        fontWeight: StyleConstants.primaryFontWeight,
                        color: StyleConstants.primaryTextColor,
                        fontSize: StyleConstants.secondaryTextSize,
                      )),
                ),
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildDeleteButton(context),
                        buildEditButton(context)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildTopCard() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: StyleConstants.secondaryGradient),
    );
  }

  Transform buildBottomCard() {
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: StyleConstants.primaryGradient),
      ),
    );
  }

  IconButton buildEditButton(BuildContext context) {
    return IconButton(
        key: Key('edit_user_${widget.user.id}'),
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
        onPressed: () => _showEditPersonForm(context, widget.project));
  }

  Widget buildDeleteButton(BuildContext context) {
    BlocProvider.of<ExpenseBloc>(context).add(GetExpensesEvent(widget.project));
    return BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (BuildContext context, ExpenseState state) {
      if (state is ExpenseLoaded) {
        final bool used = isPersonUsedInExpense(state);
        return IconButton(
            key: Key('delete_user_${widget.user.id}'),
            padding: EdgeInsets.zero,
            icon: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                FeatherIcons.trash2,
                color: used ? Colors.grey : Colors.red,
              ),
            ),
            onPressed: () async {
              if (!used) {
                await showConfirmationDialog(context);
              } else {
                DialogUtilities.showSnackBar(
                    context,
                    AppLocalizations.of(context)
                        .translate('user_list_item_used_in_expense_error'));
              }
            });
      } else if (state is ExpenseError) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('error')),
          content: Text(AppLocalizations.of(context)
              .translate('user_list_item_cannot_remove')),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context).translate('ok'))),
          ],
        );
      }
      return Container();
    });
  }

  Future showConfirmationDialog(BuildContext context) async {
    final bool result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DialogUtilities.createDeleteConfirmationDialog(context);
        });
    if (result) {
      BlocProvider.of<UserBloc>(context).add(DeleteUserEvent(widget.user.id));
      BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));
    }
  }

  bool isPersonUsedInExpense(ExpenseLoaded state) {
    return state.expenses.isNotEmpty &&
        state.expenses.any((expense) =>
            expense.user == widget.user ||
            expense.receivers.contains(widget.user));
  }

  void _showEditPersonForm(BuildContext ctx, Project project) {
    NewPersonForm.navigate(ctx, project, userToModify: widget.user);
  }
}
