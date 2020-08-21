import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../../data/models/user.dart';
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
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: DialogUtilities.createStackBehindDismiss(context),
      key: ObjectKey(widget.user),
      confirmDismiss: (DismissDirection direction) async {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            BlocProvider.of<ExpenseBloc>(context)
                .add(GetExpensesEvent(widget.project));
            return BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (BuildContext context, ExpenseState state) {
                if (state is ExpenseLoaded) {
                  if (state.expenses.isNotEmpty &&
                      state.expenses.any((expense) =>
                          expense.user == widget.user ||
                          expense.receivers.contains(widget.user))) {
                    return PlatformAlertDialog(
                      title:
                          Text(AppLocalizations.of(context).translate('error')),
                      content: Text(AppLocalizations.of(context)
                          .translate('user_list_item_used_in_expense_error')),
                      actions: <Widget>[
                        PlatformDialogAction(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                                AppLocalizations.of(context).translate('ok'))),
                      ],
                    );
                  }
                  return DialogUtilities.createDeleteConfirmationDialog(
                      context);
                } else if (state is ExpenseError) {
                  return AlertDialog(
                    title:
                        Text(AppLocalizations.of(context).translate('error')),
                    content: Text(AppLocalizations.of(context)
                        .translate('user_list_item_cannot_remove')),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                              AppLocalizations.of(context).translate('ok'))),
                    ],
                  );
                }
                return DialogUtilities.showLoadingIndicator(context);
              },
            );
          },
        );
      },
      onDismissed: (DismissDirection direction) {
        BlocProvider.of<UserBloc>(context).add(DeleteUserEvent(widget.user.id));
        BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(
            context.platformIcons.personSolid,
            color: Colors.blue,
            size: 30,
          ),
          title: Text(
            widget.user.name,
          ),
          trailing: GestureDetector(
            key: Key("${widget.user.id}_user_edit"),
            onTap: () => _showEditUserForm(context, widget.project),
            child: Icon(
              context.platformIcons.create,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  void _showEditUserForm(BuildContext ctx, Project project) {
    NewUserForm.navigate(ctx, project, userToModify: widget.user);
  }
}
