import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/project.dart';
import '../../bloc/bloc.dart';
import '../../bloc/user_bloc.dart';

class NewPersonForm extends StatefulWidget {
  final Project project;

  const NewPersonForm({Key key, this.project}) : super(key: key);

  @override
  _NewPersonFormState createState() => _NewPersonFormState();
}

class _NewPersonFormState extends State<NewPersonForm> {
  final _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitData() {
    if (_formKey.currentState.validate()) {
      final enteredName = _nameController.text;

      BlocProvider.of<UserBloc>(context)
          .add(AddUserEvent(enteredName, widget.project));
      BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
      color: Theme.of(context).backgroundColor,
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: _showForm(context),
      ),
    ));
  }

  Widget _showForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _createPersonNameTextField(context),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: const Text('Add Person'),
            onPressed: _submitData,
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).textTheme.button.color,
          )
        ],
      ),
    );
  }

  TextFormField _createPersonNameTextField(BuildContext context) {
    return new TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.person,
          size: 28,
          color: Theme.of(context).primaryColor,
        ),
        hintText: 'Enter person name',
        labelText: 'Name',
      ),
      validator: (val) => val.isEmpty ? 'Person name is required' : null,
      controller: _nameController,
    );
  }
}
