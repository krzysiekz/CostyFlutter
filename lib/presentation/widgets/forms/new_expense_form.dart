import 'package:costy/data/models/user.dart';
import 'package:costy/data/models/user_expense.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/other/currency_dropdown_field.dart';
import 'package:costy/presentation/widgets/other/custom_text_field.dart';
import 'package:costy/presentation/widgets/other/multi_select_chip.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/models/project.dart';

class NewExpenseForm extends StatefulWidget {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");

  final Project project;
  final UserExpense expenseToEdit;

  NewExpenseForm({Key key, @required this.project, this.expenseToEdit})
      : super(key: key);

  @override
  _NewExpenseFormState createState() => _NewExpenseFormState();
}

class _NewExpenseFormState extends State<NewExpenseForm> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  var _currency;
  var _user;
  var _receivers;
  var _selectedDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    BlocProvider.of<CurrencyBloc>(context).add(GetCurrenciesEvent());
    BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));
    if (widget.expenseToEdit != null) {
      _descriptionController.text = widget.expenseToEdit.description;
      _amountController.text = widget.expenseToEdit.amount.toString();
      _currency = widget.expenseToEdit.currency;
      _user = widget.expenseToEdit.user;
      _receivers = widget.expenseToEdit.receivers;
      _selectedDate = widget.expenseToEdit.dateTime;
    } else {
      _currency = widget.project.defaultCurrency;
      _selectedDate = DateTime.now();
    }
    super.initState();
  }

  void _submitData() {
    if (_formKey.currentState.validate()) {
      final enteredDescription = _descriptionController.text;
      final enteredAmount = _amountController.text;

      if (widget.expenseToEdit == null) {
        BlocProvider.of<ExpenseBloc>(context).add(AddExpenseEvent(
            project: widget.project,
            amount: Decimal.parse(enteredAmount),
            currency: _currency,
            user: _user,
            receivers: _receivers,
            description: enteredDescription,
            dateTime: _selectedDate));
      } else {
        final UserExpense edited = UserExpense(
            id: widget.expenseToEdit.id,
            amount: Decimal.parse(enteredAmount),
            currency: _currency,
            user: _user,
            receivers: _receivers,
            description: enteredDescription,
            dateTime: _selectedDate);
        BlocProvider.of<ExpenseBloc>(context).add(ModifyExpenseEvent(edited));
      }
      BlocProvider.of<ExpenseBloc>(context)
          .add(GetExpensesEvent(widget.project));
      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(DateTime.now().year - 1),
        maxTime: DateTime.now(), onConfirm: (date) {
      setState(() {
        _selectedDate = date;
      });
    }, currentTime: _selectedDate == null ? DateTime.now() : _selectedDate);
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
      elevation: 0,
      color: Theme.of(context).backgroundColor,
      child: Container(
        padding: EdgeInsets.only(
          top: 5,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 5,
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
              const SizedBox(width: 15),
              Expanded(child: _createCurrencyDropDownList(context)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(child: _createUserDropDownList(context)),
              const SizedBox(width: 15),
              Expanded(child: _createDatePicker(context)),
            ],
          ),
          _createReceiversWidget(context),
          const SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: widget.expenseToEdit == null
                ? const Text('Add Expense')
                : const Text('Edit Expense'),
            onPressed: _submitData,
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).textTheme.button.color,
          )
        ],
      ),
    );
  }

  Widget _createDatePicker(BuildContext context) {
    return FormField<DateTime>(
      initialValue: _selectedDate == null ? DateTime.now() : _selectedDate,
      builder: (FormFieldState<DateTime> formState) {
        return InputDecorator(
            decoration: InputDecoration(
              icon: Icon(
                Icons.date_range,
                size: 26,
                color: Theme.of(context).primaryColor,
              ),
              errorText: formState.hasError ? formState.errorText : null,
            ),
            child: Container(
              child: FlatButton(
                textColor: Theme.of(context).primaryColor,
                onPressed: _presentDatePicker,
                child: Text(_selectedDate == null
                    ? 'No Date Chosen'
                    : widget.dateFormat.format(_selectedDate)),
              ),
            ));
      },
      validator: (val) {
        return (val == null) ? 'Please select date' : null;
      },
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
                initialValue: _currency,
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
            return _createItemDropDown(context, state.users);
          }
          return Container();
        });
  }

  FormField<User> _createItemDropDown(BuildContext context, List<User> users) {
    return FormField<User>(
      builder: (FormFieldState<User> formState) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: Icon(
              Icons.person,
              size: 26,
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
      initialValue: _user,
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
              initialValue: _receivers == null ? state.users : _receivers,
              builder: (FormFieldState<List<User>> formState) {
                return InputDecorator(
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.group,
                        size: 26,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Receivers',
                      errorText:
                          formState.hasError ? formState.errorText : null,
                    ),
                    child: MultiSelectChip(
                      initialUserList: _receivers,
                      userList: state.users,
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
