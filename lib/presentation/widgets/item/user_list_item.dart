import 'package:flutter/material.dart';

import '../../../data/models/user.dart';

class UserListItem extends StatefulWidget {
  final User user;

  UserListItem({Key key, this.user}) : super(key: key);

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
      ),
    );
  }
}
