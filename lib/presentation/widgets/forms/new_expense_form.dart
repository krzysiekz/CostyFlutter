import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/models/project.dart';

class NewExpenseForm extends StatefulWidget {
  final Project project;

  const NewExpenseForm({Key key, this.project}) : super(key: key);

  @override
  _NewExpenseFormState createState() => _NewExpenseFormState();
}

class _NewExpenseFormState extends State<NewExpenseForm> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitData() {
    if (_formKey.currentState.validate()) {
      final enteredDescription = _descriptionController.text;

      Navigator.of(context).pop();
    }
  }

  String _numberValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
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
          _createDescriptionTextField(context),
          _createAmountTextField(context),
          const SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: const Text('Add Expense'),
            onPressed: _submitData,
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).textTheme.button.color,
          )
        ],
      ),
    );
  }

  TextFormField _createAmountTextField(BuildContext context) {
    return new TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        icon: Icon(
          Icons.attach_money,
          size: 28,
          color: Theme.of(context).primaryColor,
        ),
        hintText: 'Enter Amount',
        labelText: 'Amount',
      ),
      validator: _numberValidator,
      controller: _descriptionController,
    );
  }

  TextFormField _createDescriptionTextField(BuildContext context) {
    return new TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.note,
          size: 28,
          color: Theme.of(context).primaryColor,
        ),
        hintText: 'Enter Description',
        labelText: 'Description',
      ),
      validator: (val) => val.isEmpty ? 'Description is required' : null,
      controller: _amountController,
    );
  }
}
