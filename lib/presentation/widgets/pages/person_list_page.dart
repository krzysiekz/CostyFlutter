import 'package:flutter/material.dart';

class PersonListPage extends StatefulWidget {
  PersonListPage({Key key}) : super(key: key);

  @override
  _PersonListPageState createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Person list'),
    );
  }
}
