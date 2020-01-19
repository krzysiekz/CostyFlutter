import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/project.dart';
import '../../bloc/bloc.dart';
import '../../bloc/user_bloc.dart';
import '../item/user_list_item.dart';

class UserListPage extends StatefulWidget {
  final Project project;

  UserListPage({Key key, this.project}) : super(key: key);

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
          return Text("No users to display.");
        } else if (state is UserLoaded) {
          return GridView.builder(
            padding: const EdgeInsets.all(25),
            itemBuilder: (cts, index) {
              return UserListItem(user: state.users[index]);
            },
            itemCount: state.users.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
          );
        } else if (state is UserLoading) {
          return _showLoadingIndicator(context);
        }
        return Container();
      },
      listener: (BuildContext context, UserState state) {
        if (state is UserError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showAlertDialog(context);
          });
        } else if (state is UserAdded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: const Text("User added."),
            ));
          });
        }
      },
    );
  }

  Column _showLoadingIndicator(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: 20,
            width: 20,
            margin: EdgeInsets.all(5),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Cannot add user.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
