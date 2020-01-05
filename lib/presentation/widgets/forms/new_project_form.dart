import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/currency.dart';
import '../../../injection_container.dart';
import '../../bloc/currency_bloc.dart';
import '../../bloc/currency_event.dart';
import '../../bloc/currency_state.dart';

class NewProjectForm extends StatefulWidget {
  final Function addTx;

  NewProjectForm(this.addTx);

  @override
  _NewProjectFormState createState() => _NewProjectFormState();
}

class _NewProjectFormState extends State<NewProjectForm> {
  final _nameController = TextEditingController();
  var _defaultCurrency;

  final _formKey = GlobalKey<FormState>();
  CurrencyBloc _currencyBloc;

  void _submitData() {
    if (_formKey.currentState.validate()) {
      final enteredName = _nameController.text;
      final enteredDefaultCurrency = _defaultCurrency;

      widget.addTx(
        enteredName,
        enteredDefaultCurrency,
      );

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    this._currencyBloc = ic<CurrencyBloc>();
    _currencyBloc.add(GetCurrenciesEvent());
    super.initState();
  }

  @override
  void dispose() {
    _currencyBloc.close();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<CurrencyBloc, CurrencyState>(
          bloc: _currencyBloc,
          listener: (context, state) {
            if (state is CurrencyError) {
              _showAlertDialog(context);
            }
          },
          builder: (context, state) {
            return Card(
              color: Theme.of(context).backgroundColor,
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                child: _buildForm(context, state),
              ),
            );
          }),
    );
  }

  Widget _buildForm(BuildContext context, CurrencyState state) {
    if (state is CurrencyLoaded) {
      return _showForm(context, state);
    } else if (state is CurrencyLoading) {
      return _showLoadingIndicator(context);
    } else {
      return new Container();
    }
  }

  Widget _showLoadingIndicator(BuildContext context) {
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

  Widget _showForm(BuildContext context, CurrencyLoaded state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _createProjectNameTextField(context),
          SizedBox(
            height: 20,
          ),
          _createCurrencyDropdownField(context, state),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: const Text('Add Project'),
            onPressed: _submitData,
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).textTheme.button.color,
          )
        ],
      ),
    );
  }

  FormField<String> _createCurrencyDropdownField(
      BuildContext context, CurrencyLoaded state) {
    return new FormField<String>(
      builder: (FormFieldState<String> formState) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: Icon(
              Icons.monetization_on,
              size: 28,
              color: Theme.of(context).primaryColor,
            ),
            labelText: 'Default Currency',
            errorText: formState.hasError ? formState.errorText : null,
          ),
          isEmpty: _defaultCurrency == '',
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<String>(
              icon: Icon(
                Icons.arrow_downward,
                color: Theme.of(context).primaryColor,
              ),
              value: _defaultCurrency,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _defaultCurrency = newValue;
                  formState.didChange(newValue);
                });
              },
              items: state.currencies
                  .map<DropdownMenuItem<String>>((Currency currency) {
                return DropdownMenuItem<String>(
                  value: currency.name,
                  child: Text(currency.name),
                );
              }).toList(),
            ),
          ),
        );
      },
      validator: (val) {
        return (val == null || val.isEmpty)
            ? 'Please select a default currency'
            : null;
      },
    );
  }

  TextFormField _createProjectNameTextField(BuildContext context) {
    return new TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.text_fields,
          size: 28,
          color: Theme.of(context).primaryColor,
        ),
        hintText: 'Enter project name',
        labelText: 'Name',
      ),
      validator: (val) => val.isEmpty ? 'Project name is required' : null,
      controller: _nameController,
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: const Text('Cannot fetch available currencies.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
