import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/user.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  var _currency;
  var _userId;
  var _receiversIds;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    BlocProvider.of<CurrencyBloc>(context).add(GetCurrenciesEvent());
    BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));
    _currency = widget.project.defaultCurrency.name;
    super.initState();
  }

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
          _createCurrencyDropDownList(context),
          _createUserDropDownList(context),
          _createReceiversCheckBoxes(context),
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

  Widget _createAmountTextField(BuildContext context) {
    return TextFormField(
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

  Widget _createDescriptionTextField(BuildContext context) {
    return TextFormField(
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

  Widget _createCurrencyDropDownList(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
        bloc: BlocProvider.of<CurrencyBloc>(context),
        builder: (context, state) {
          if (state is CurrencyLoaded) {
            return FormField<String>(
              initialValue: widget.project.defaultCurrency.name,
              builder: (FormFieldState<String> formState) {
                return InputDecorator(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.monetization_on,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                    labelText: 'Currency',
                    errorText: formState.hasError ? formState.errorText : null,
                  ),
                  isEmpty: _currency == '',
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      icon: Icon(
                        Icons.arrow_downward,
                        color: Theme.of(context).primaryColor,
                      ),
                      value: _currency,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _currency = newValue;
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
                    ? 'Please select a currency'
                    : null;
              },
            );
          }
          return Container();
        });
  }

  Widget _createUserDropDownList(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        bloc: BlocProvider.of<UserBloc>(context),
        builder: (context, state) {
          if (state is UserLoaded) {
            return FormField<int>(
              builder: (FormFieldState<int> formState) {
                return InputDecorator(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                    labelText: 'User',
                    errorText: formState.hasError ? formState.errorText : null,
                  ),
                  isEmpty: _userId == '',
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<int>(
                      icon: Icon(
                        Icons.arrow_downward,
                        color: Theme.of(context).primaryColor,
                      ),
                      value: _userId,
                      isDense: true,
                      onChanged: (int newValue) {
                        setState(() {
                          _userId = newValue;
                          formState.didChange(newValue);
                        });
                      },
                      items:
                          state.users.map<DropdownMenuItem<int>>((User user) {
                        return DropdownMenuItem<int>(
                          value: user.id,
                          child: Text(user.name),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              validator: (val) {
                return (val == null) ? 'Please select a user' : null;
              },
            );
          }
          return Container();
        });
  }

  Widget _createReceiversCheckBoxes(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        bloc: BlocProvider.of<UserBloc>(context),
        builder: (context, state) {
          if (state is UserLoaded) {
            return FormField<List<int>>(
              initialValue: state.users.map((user) => user.id).toList(),
              builder: (FormFieldState<List<int>> formState) {
                return InputDecorator(
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.group,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Receivers',
                      errorText:
                          formState.hasError ? formState.errorText : null,
                    ),
                    child: MultiSelectChip(
                      state.users,
                      onSelectionChanged: (selectedList) {
                        setState(() {
                          _receiversIds = selectedList;
                          formState.didChange(selectedList);
                        });
                      },
                    ));
              },
              validator: (val) {
                return (val == null || val.length < 1)
                    ? 'Please select receivers'
                    : null;
              },
            );
          }
          return Container();
        });
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<User> userList;
  final Function(List<int>) onSelectionChanged;

  MultiSelectChip(this.userList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<int> _selectedUserIds = List();

  @override
  void initState() {
    _selectedUserIds = widget.userList.map((user) => user.id).toList();
    super.initState();
  }

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.userList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item.name),
          selected: _selectedUserIds.contains(item.id),
          onSelected: (selected) {
            setState(() {
              _selectedUserIds.contains(item.id)
                  ? _selectedUserIds.remove(item.id)
                  : _selectedUserIds.add(item.id);
              widget.onSelectionChanged(_selectedUserIds);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
