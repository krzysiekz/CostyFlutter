import 'package:costy/presentation/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/currency.dart';
import '../../bloc/bloc.dart';
import '../../bloc/currency_bloc.dart';
import '../../bloc/currency_state.dart';
import '../../bloc/project_bloc.dart';

class NewProjectForm extends StatefulWidget {
  @override
  _NewProjectFormState createState() => _NewProjectFormState();
}

class _NewProjectFormState extends State<NewProjectForm> {
  final _nameController = TextEditingController();
  var _defaultCurrency;

  final _formKey = GlobalKey<FormState>();

  void _submitData() {
    if (_formKey.currentState.validate()) {
      final enteredName = _nameController.text;

      BlocProvider.of<ProjectBloc>(context).add(AddProjectEvent(
          projectName: enteredName, defaultCurrency: _defaultCurrency));
      BlocProvider.of<ProjectBloc>(context).add(GetProjectsEvent());

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    BlocProvider.of<CurrencyBloc>(context).add(GetCurrenciesEvent());
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<CurrencyBloc, CurrencyState>(
          bloc: BlocProvider.of<CurrencyBloc>(context),
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
    } else {
      return new Container();
    }
  }

  Widget _showForm(BuildContext context, CurrencyLoaded state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          CustomTextField(
            icon: Icons.text_fields,
            hintText: 'Enter project name',
            labelText: 'Project name',
            controller: _nameController,
            validator: (val) => val.isEmpty ? 'Project name is required' : null,
          ),
          const SizedBox(
            height: 20,
          ),
          _createCurrencyDropdownField(context, state),
          const SizedBox(
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

  FormField<Currency> _createCurrencyDropdownField(
      BuildContext context, CurrencyLoaded state) {
    return FormField<Currency>(
      builder: (FormFieldState<Currency> formState) {
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
          isEmpty: _defaultCurrency == null,
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<Currency>(
              icon: Icon(
                Icons.arrow_downward,
                color: Theme.of(context).primaryColor,
              ),
              value: _defaultCurrency,
              isDense: true,
              onChanged: (Currency newValue) {
                setState(() {
                  _defaultCurrency = newValue;
                  formState.didChange(newValue);
                });
              },
              items: state.currencies
                  .map<DropdownMenuItem<Currency>>((Currency currency) {
                return DropdownMenuItem<Currency>(
                  value: currency,
                  child: Text(currency.name),
                );
              }).toList(),
            ),
          ),
        );
      },
      validator: (val) {
        return (val == null) ? 'Please select a default currency' : null;
      },
    );
  }
}
