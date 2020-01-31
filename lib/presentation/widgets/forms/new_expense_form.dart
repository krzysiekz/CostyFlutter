import 'package:costy/data/models/user.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/other/currency_dropdown_field.dart';
import 'package:costy/presentation/widgets/other/custom_text_field.dart';
import 'package:costy/presentation/widgets/other/multi_select_chip.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
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
  var _user;
  var _receivers;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    BlocProvider.of<CurrencyBloc>(context).add(GetCurrenciesEvent());
    BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));
    _currency = widget.project.defaultCurrency;
    super.initState();
  }

  void _submitData() {
    if (_formKey.currentState.validate()) {
      final enteredDescription = _descriptionController.text;
      final enteredAmount = _amountController.text;

      BlocProvider.of<ExpenseBloc>(context).add(AddExpenseEvent(
          project: widget.project,
          amount: Decimal.parse(enteredAmount),
          currency: _currency,
          user: _user,
          receivers: _receivers,
          description: enteredDescription));
      BlocProvider.of<ExpenseBloc>(context)
          .add(GetExpensesEvent(widget.project));
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
          CustomTextField(
            icon: Icons.note,
            hintText: 'Enter description',
            labelText: 'Description',
            controller: _descriptionController,
            validator: (val) => val.isEmpty ? 'Description is required' : null,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: CustomTextField(
                  icon: Icons.attach_money,
                  hintText: 'Enter amount',
                  labelText: 'Amount',
                  controller: _amountController,
                  validator: _numberValidator,
                  textInputType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Expanded(child: _createCurrencyDropDownList(context)),
            ],
          ),
          _createUserDropDownList(context),
          _createReceiversWidget(context),
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

  Widget _createCurrencyDropDownList(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
        bloc: BlocProvider.of<CurrencyBloc>(context),
        builder: (context, state) {
          if (state is CurrencyLoaded) {
            return CurrencyDropdownField(
                currencies: state.currencies,
                label: 'Currency',
                callback: (newValue) {
                  setState(() {
                    _currency = newValue;
                  });
                });
          }
          return Container();
        });
  }

  Widget _createUserDropDownList(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        bloc: BlocProvider.of<UserBloc>(context),
        builder: (context, state) {
          if (state is UserLoaded) {
            return creteItemDropDown(context, state.users);
          }
          return Container();
        });
  }

  FormField<User> creteItemDropDown(BuildContext context, List<User> users) {
    return FormField<User>(
      builder: (FormFieldState<User> formState) {
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
          isEmpty: _user == null,
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<User>(
              isExpanded: true,
              icon: Icon(
                Icons.arrow_downward,
                color: Theme.of(context).primaryColor,
              ),
              value: _user,
              isDense: true,
              onChanged: (User newValue) {
                setState(() {
                  _user = newValue;
                  formState.didChange(newValue);
                });
              },
              items: getUsersDropdownItems(users),
            ),
          ),
        );
      },
      validator: (val) {
        return (val == null) ? 'Please select a user' : null;
      },
    );
  }

  List<DropdownMenuItem<User>> getUsersDropdownItems(List<User> users) {
    return users.map<DropdownMenuItem<User>>((User user) {
      return DropdownMenuItem<User>(
        value: user,
        child: Text(user.name,
            overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
      );
    }).toList();
  }

  Widget _createReceiversWidget(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        bloc: BlocProvider.of<UserBloc>(context),
        builder: (context, state) {
          if (state is UserLoaded) {
            return FormField<List<User>>(
              initialValue: state.users,
              builder: (FormFieldState<List<User>> formState) {
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
                          _receivers = selectedList;
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
