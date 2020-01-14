import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/user_bloc.dart';

class PersonListPage extends StatefulWidget {
  PersonListPage({Key key}) : super(key: key);

  @override
  _PersonListPageState createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  @override
  Widget build(BuildContext context) {
    final usersBloc = BlocProvider.of<UserBloc>(context);
    return Container(
      child: Text('Person list'),
    );
  }
}
