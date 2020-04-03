import 'package:costy/data/models/project.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/forms/new_user_form.dart';
import 'package:costy/presentation/widgets/utilities/dialog_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../data/models/user.dart';

class UserListItem extends StatefulWidget {
  final User user;
  final Project project;

  UserListItem({Key key, @required this.user, @required this.project})
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(
            context.platformIcons.personSolid,
            color: IconTheme.of(context).color,
            size: 40,
          ),
          title: Text(
            widget.user.name,
          ),
          trailing: GestureDetector(
            onTap: () => _showEditUserForm(context, widget.project),
            child: Icon(
              context.platformIcons.create,
              color: IconTheme.of(context).color,
            ),
          ),
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
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
    );
  }

  void _showEditUserForm(BuildContext ctx, Project project) {
    showPlatformModalSheet(
      context: ctx,
      builder: (_) {
        return NewUserForm(project: project, userToModify: widget.user);
      },
    );
  }
}
