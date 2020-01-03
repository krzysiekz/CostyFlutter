import 'package:costy/data/models/currency.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/bloc/currency_state.dart';

import '../bloc/currency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection_container.dart';

class NewProject extends StatefulWidget {
  final Function addTx;

  NewProject(this.addTx);

  @override
  _NewProjectState createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider(
        child:
            BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, state) {
          return Card(
            child: Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              child: buildForm(context, state),
            ),
          );
        }),
        create: (_) => _currencyBloc,
      ),
    );
  }

  Widget buildForm(BuildContext context, CurrencyState state) {
    if (state is CurrencyError) {
      return showAlertDialog(context);
    } else if (state is CurrencyLoaded) {
      return showForm(context, state);
    } else {
      return showLoadingIndicator(context);
    }
  }

  Column showLoadingIndicator(BuildContext context) {
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

  Widget showForm(BuildContext context, CurrencyLoaded state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new TextFormField(
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
          ),
          SizedBox(
            height: 20,
          ),
          new FormField<String>(
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
          ),
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

  AlertDialog showAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      content: const Text('Cannot fetch available currencies.'),
      actions: <Widget>[
        FlatButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
