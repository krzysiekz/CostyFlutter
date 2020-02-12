import 'package:costy/data/models/project.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/forms/new_user_form.dart';
import 'package:costy/presentation/widgets/utilities/dialog_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          leading: Icon(
            Icons.person,
            color: Theme.of(context).accentColor,
            size: 40,
          ),
          title: Text(
            widget.user.name,
            style: TextStyle(color: Colors.white70),
          ),
          trailing: GestureDetector(
            onTap: () => _showEditUserForm(context, widget.project),
            child: Icon(
              Icons.edit,
              color: Theme.of(context).accentColor,
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
                    return AlertDialog(
                      title: const Text("Error"),
                      content: const Text(
                          "Cannot remove user that is used in expense. Please remove expense first."),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("OK")),
                      ],
                    );
                  }
                  return DialogUtilities.createDeleteConfirmationDialog(
                      context);
                } else if (state is ExpenseError) {
                  return AlertDialog(
                    title: const Text("Error"),
                    content: const Text("Cannot remove user."),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("OK")),
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
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      context: ctx,
      builder: (_) {
        return NewUserForm(project: project, userToModify: widget.user);
      },
    );
  }
}
