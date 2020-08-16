import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../bloc/bloc.dart';
import '../../bloc/user_bloc.dart';
import '../item/user_list_item.dart';
import '../utilities/dialog_utilities.dart';

class UserListPage extends StatefulWidget {
  final Project project;

  const UserListPage({Key key, @required this.project}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      builder: (BuildContext context, UserState state) {
        if (state is UserEmpty) {
          return Text(AppLocalizations.of(context)
              .translate('user_list_page_no_users'));
        } else if (state is UserLoaded) {
          if (state.users.isEmpty) {
            return Text(AppLocalizations.of(context)
                .translate('user_list_page_no_users'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemBuilder: (cts, index) {
              return UserListItem(
                key: Key("user_${state.users[index].id}"),
                user: state.users[index],
                project: widget.project,
              );
            },
            itemCount: state.users.length,
          );
        } else if (state is UserLoading) {
          return DialogUtilities.showLoadingIndicator(context);
        }
        return Container();
      },
      listener: (BuildContext context, UserState state) {
        if (state is UserError) {
          DialogUtilities.showAlertDialog(
              context,
              AppLocalizations.of(context).translate('error'),
              AppLocalizations.of(context)
                  .translate('user_list_page_cannot_add'));
        } else if (state is UserAdded) {
          DialogUtilities.showSnackBar(context,
              AppLocalizations.of(context).translate('user_list_page_added'));
        } else if (state is UserDeleted) {
          DialogUtilities.showSnackBar(context,
              AppLocalizations.of(context).translate('user_list_page_deleted'));
        } else if (state is UserModified) {
          DialogUtilities.showSnackBar(
              context,
              AppLocalizations.of(context)
                  .translate('user_list_page_modified'));
        }
      },
    );
  }
}
