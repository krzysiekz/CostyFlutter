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

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../../keys.dart';

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
      return AppLocalizations.of(context)
          .translate('expense_form_amount_required');
    }
    final n = num.tryParse(value);
    if (n == null) {
      return AppLocalizations.of(context)
          .translate('expense_form_not_a_valid_number');
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
            textFormFieldKey: Key(Keys.EXPENSE_FORM_DESCRIPTION_FIELD_KEY),
            icon: Icons.note,
            hintText: AppLocalizations.of(context)
                .translate('expense_form_description_hint'),
            labelText: AppLocalizations.of(context)
                .translate('expense_form_description_label'),
            controller: _descriptionController,
            validator: (val) => val.isEmpty
                ? AppLocalizations.of(context)
                    .translate('expense_form_description_error')
                : null,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: CustomTextField(
                  textFormFieldKey: Key(Keys.EXPENSE_FORM_AMOUNT_FIELD_KEY),
                  icon: Icons.attach_money,
                  hintText: AppLocalizations.of(context)
                      .translate('expense_form_amount_hint'),
                  labelText: AppLocalizations.of(context)
                      .translate('expense_form_amount_label'),
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
            key: Key(Keys.EXPENSE_FORM_ADD_EDIT_BUTTON_KEY),
            child: widget.expenseToEdit == null
                ? Text(AppLocalizations.of(context)
                    .translate('expense_form_add_expense_button'))
                : Text(AppLocalizations.of(context)
                    .translate('expense_form_modify_expense_button')),
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
                    ? AppLocalizations.of(context)
                        .translate('expense_form_date_no_chosen')
                    : widget.dateFormat.format(_selectedDate)),
              ),
            ));
      },
      validator: (val) {
        return (val == null)
            ? AppLocalizations.of(context).translate('expense_form_date_error')
            : null;
      },
    );
  }

  Widget _createCurrencyDropDownList(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
        bloc: BlocProvider.of<CurrencyBloc>(context),
        builder: (context, state) {
          if (state is CurrencyLoaded) {
            return CurrencyDropdownField(
                key: Key(Keys.EXPENSE_FORM_CURRENCY_KEY),
                currencies: state.currencies,
                label: AppLocalizations.of(context)
                    .translate('expense_form_currency_label'),
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
      key: Key(Keys.EXPENSE_FORM_USER_KEY),
      builder: (FormFieldState<User> formState) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: Icon(
              Icons.person,
              size: 26,
              color: Theme.of(context).primaryColor,
            ),
            labelText: AppLocalizations.of(context)
                .translate('expense_form_user_label'),
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
        return (val == null)
            ? AppLocalizations.of(context).translate('expense_form_user_error')
            : null;
      },
      initialValue: _user,
    );
  }

  List<DropdownMenuItem<User>> getUsersDropdownItems(List<User> users) {
    return users.map<DropdownMenuItem<User>>((User user) {
      return DropdownMenuItem<User>(
        key: Key('user_${user.id}'),
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
                      labelText: AppLocalizations.of(context)
                          .translate('expense_form_receivers_label'),
                      errorText:
                          formState.hasError ? formState.errorText : null,
                    ),
                    child: MultiSelectChip(
                      key: Key(Keys.EXPENSE_FORM_RECEIVERS_FIELD_KEY),
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
                    ? AppLocalizations.of(context)
                        .translate('expense_form_receivers_error')
                    : null;
              },
            );
          }
          return Container();
        });
  }
}
