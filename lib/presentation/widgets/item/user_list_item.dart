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
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.person,
            color: Theme.of(context).accentColor,
            size: 40,
          ),
          Expanded(
            child: Text(
              widget.user.name,
              style: TextStyle(color: Colors.white70),
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
