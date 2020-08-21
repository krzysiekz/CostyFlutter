import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';

import '../../../app_localizations.dart';
import '../../../data/models/currency.dart';
import '../../../data/models/project.dart';
import '../../../data/models/user.dart';
import '../../../data/models/user_expense.dart';
import '../../../keys.dart';
import '../../bloc/bloc.dart';
import '../other/currency_dropdown_field.dart';
import '../other/custom_scaffold.dart';
import '../other/custom_text_field.dart';
import '../other/receivers_widget_form_field.dart';

class NewExpenseForm extends StatefulWidget {
  static void navigate(BuildContext buildContext, Project project,
      {UserExpense expenseToEdit}) {
    Navigator.of(buildContext).push(platformPageRoute(
      context: buildContext,
      builder: (BuildContext context) =>
          NewExpenseForm(project: project, expenseToEdit: expenseToEdit),
    ));
  }

  static final DateFormat dateFormat = DateFormat("dd/MM HH:mm");

  final Project project;
  final UserExpense expenseToEdit;

  const NewExpenseForm({Key key, @required this.project, this.expenseToEdit})
      : super(key: key);

  @override
  _NewExpenseFormState createState() => _NewExpenseFormState();
}

class _NewExpenseFormState extends State<NewExpenseForm> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  Currency _currency;
  User _user;
  List<User> _receivers;
  DateTime _selectedDate;

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
      BlocProvider.of<ReportBloc>(context).add(GetReportEvent(widget.project));
      Navigator.of(context).pop();
    }
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
    final title = widget.expenseToEdit == null
        ? AppLocalizations.of(context)
            .translate('expense_form_add_expense_button')
        : AppLocalizations.of(context)
            .translate('expense_form_modify_expense_button');
    return CustomScaffold(
      appBarTitle: title,
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: 10,
        ),
        child: _showForm(context),
      )),
    );
  }

  Widget _showForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          CustomTextField(
            textFormFieldKey: const Key(Keys.expenseFormDescriptionFieldKey),
            hintText: AppLocalizations.of(context)
                .translate('expense_form_description_hint'),
            controller: _descriptionController,
            validator: (String val) => val.isEmpty
                ? AppLocalizations.of(context)
                    .translate('expense_form_description_error')
                : null,
            iconData: context.platformIcons.shoppingCart,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: CustomTextField(
                  textFormFieldKey: const Key(Keys.expenseFormAcountFieldKey),
                  hintText: AppLocalizations.of(context)
                      .translate('expense_form_amount_hint'),
                  controller: _amountController,
                  validator: _numberValidator,
                  textInputType:
                      const TextInputType.numberWithOptions(decimal: true),
                  iconData: context.platformIcons.tag,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(child: _createCurrencyDropDownList(context)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                  child: _UserDropDownFormField(
                initialValue: _user,
                onChangedCallback: (User newValue) {
                  setState(() {
                    _user = newValue;
                  });
                },
              )),
              const SizedBox(width: 15),
              Expanded(
                  child: _DateTimePickerFormField(
                selectedValue: _selectedDate,
                onConfirmFunction: (DateTime date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ReceiversWidgetFormField(
              initialReceivers: _receivers,
              onSelectionChangedFunction: (List<User> selectedList) {
                setState(() {
                  _receivers = selectedList;
                });
              }),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              PlatformButton(
                materialFlat: (_, platform) => MaterialFlatButtonData(
                  textColor: Theme.of(context).errorColor,
                ),
                key: const Key(Keys.projectFormCancelButtonKey),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)
                    .translate('form_cancel_button')),
              ),
              PlatformButton(
                key: const Key(Keys.expenseFormAddEditButtonKey),
                onPressed: _submitData,
                child: widget.expenseToEdit == null
                    ? Text(AppLocalizations.of(context)
                        .translate('expense_form_add_expense_button'))
                    : Text(AppLocalizations.of(context)
                        .translate('expense_form_modify_expense_button')),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _createCurrencyDropDownList(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, state) {
      if (state is CurrencyLoaded) {
        return CurrencyDropdownField(
            key: const Key(Keys.expenseFormCurrencyKey),
            currencies: state.currencies,
            initialValue: _currency,
            callback: (Currency newValue) {
              setState(() {
                _currency = newValue;
              });
            });
      }
      return Container();
    });
  }
}

class _UserDropDownFormField extends StatelessWidget {
  final User initialValue;
  final Function onChangedCallback;

  const _UserDropDownFormField(
      {Key key, this.initialValue, this.onChangedCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserLoaded) {
        return Container(
            margin: const EdgeInsets.only(right: 5, left: 5),
            child: FormField<User>(
              key: const Key(Keys.expenseFormUserKey),
              builder: (FormFieldState<User> formState) {
                return InputDecorator(
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                    prefixIcon: Icon(
                      context.platformIcons.person,
                      color: Colors.blue,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    isDense: true,
                    errorText: formState.hasError ? formState.errorText : null,
                    hintText: AppLocalizations.of(context)
                        .translate('expense_form_user_hint'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  isEmpty: initialValue == null,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<User>(
                      isExpanded: true,
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.blue,
                      ),
                      value: initialValue,
                      isDense: true,
                      onChanged: (User newValue) {
                        formState.didChange(newValue);
                        onChangedCallback(newValue);
                      },
                      items: _getUsersDropdownItems(state.users),
                    ),
                  ),
                );
              },
              validator: (val) {
                return (val == null)
                    ? AppLocalizations.of(context)
                        .translate('expense_form_user_error')
                    : null;
              },
              initialValue: initialValue,
            ));
      }
      return Container();
    });
  }

  List<DropdownMenuItem<User>> _getUsersDropdownItems(List<User> users) {
    return users.map<DropdownMenuItem<User>>((User user) {
      return DropdownMenuItem<User>(
        key: Key('user_${user.id}'),
        value: user,
        child: Text(user.name,
            overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
      );
    }).toList();
  }
}

class _DateTimePickerFormField extends StatelessWidget {
  final DateTime selectedValue;
  final Function(DateTime) onConfirmFunction;

  const _DateTimePickerFormField(
      {Key key, this.selectedValue, this.onConfirmFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5),
      child: FormField<DateTime>(
        initialValue: selectedValue ?? DateTime.now(),
        builder: (FormFieldState<DateTime> formState) {
          return InputDecorator(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                isDense: true,
                errorText: formState.hasError ? formState.errorText : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
              ),
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.all(0),
                onPressed: () => _presentDatePicker(context),
                child: Text(NewExpenseForm.dateFormat.format(selectedValue)),
              ));
        },
        validator: (val) {
          return (val == null)
              ? AppLocalizations.of(context)
                  .translate('expense_form_date_error')
              : null;
        },
      ),
    );
  }

  Future<void> _presentDatePicker(BuildContext ctx) async {
    if (isMaterial(ctx)) {
      final date = await showDatePicker(
          context: ctx,
          firstDate: DateTime(DateTime.now().year - 1),
          initialDate: selectedValue ?? DateTime.now(),
          lastDate: DateTime.now());
      if (date != null) {
        final time = await showTimePicker(
          context: ctx,
          initialTime: TimeOfDay.fromDateTime(selectedValue ?? DateTime.now()),
        );
        return onConfirmFunction(_combine(date, time));
      } else {
        return onConfirmFunction(selectedValue);
      }
    } else {
      await showCupertinoModalPopup(
          context: ctx,
          builder: (BuildContext context) => _buildBottomPicker(
              CupertinoDatePicker(
                  use24hFormat: true,
                  maximumDate: DateTime.now(),
                  minimumDate: DateTime(DateTime.now().year - 1),
                  initialDateTime: selectedValue ?? DateTime.now(),
                  onDateTimeChanged: onConfirmFunction)));
    }
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 216.0,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  DateTime _combine(DateTime date, TimeOfDay time) => DateTime(
      date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);
}