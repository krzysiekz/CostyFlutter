import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/project.dart';
import '../../bloc/bloc.dart';
import '../../bloc/user_bloc.dart';
import '../item/user_list_item.dart';
import '../utilities/dialog_utilities.dart';

class UserListPage extends StatefulWidget {
  final Project project;

  UserListPage({Key key, @required this.project}) : super(key: key);

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
      bloc: BlocProvider.of<UserBloc>(context),
      builder: (BuildContext context, UserState state) {
        if (state is UserEmpty) {
          return const Text("No users to display.");
        } else if (state is UserLoaded) {
          if (state.users.isEmpty) {
            return const Text("No users to display.");
          }
          return ListView.builder(
            padding: const EdgeInsets.all(25),
            itemBuilder: (cts, index) {
              return UserListItem(user: state.users[index]);
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
          DialogUtilities.showAlertDialog(context, 'Error', 'Cannot add user');
        } else if (state is UserAdded) {
          DialogUtilities.showSnackBar(context, 'User added.');
        }
      },
    );
  }
}
