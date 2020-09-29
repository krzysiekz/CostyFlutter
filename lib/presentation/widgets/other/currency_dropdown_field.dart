import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../app_localizations.dart';
import '../../../data/models/currency.dart';
import '../../../style_constants.dart';

class CurrencyDropdownField extends StatefulWidget {
  final List<Currency> currencies;
  final Function callback;
  final Currency initialValue;

  const CurrencyDropdownField(
      {Key key,
      @required this.currencies,
      @required this.callback,
      this.initialValue})
      : super(key: key);

  @override
  _CurrencyDropdownFieldState createState() => _CurrencyDropdownFieldState();
}

class _CurrencyDropdownFieldState extends State<CurrencyDropdownField> {
  Currency _selected;

  @override
  void initState() {
    _selected = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FormField<Currency>(
        initialValue: widget.initialValue,
        builder: (FormFieldState<Currency> formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  AppLocalizations.of(context)
                      .translate('form_currency_dropdown_hint'),
                  style: const TextStyle(
                    fontWeight: StyleConstants.buttonsTextFontWeight,
                    color: StyleConstants.formLabelColor,
                    fontSize: StyleConstants.buttonsTextSize,
                  )),
              InputDecorator(
                decoration: InputDecoration(
                  isDense: true,
                  errorText: formState.hasError ? formState.errorText : null,
                  border: const UnderlineInputBorder(),
                ),
                isEmpty: _selected == null,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Currency>(
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.blue,
                    ),
                    value: _selected,
                    isDense: true,
                    onChanged: (Currency newValue) {
                      setState(() {
                        _selected = newValue;
                        formState.didChange(newValue);
                        widget.callback(newValue);
                      });
                    },
                    items: widget.currencies
                        .map<DropdownMenuItem<Currency>>((Currency currency) {
                      return DropdownMenuItem<Currency>(
                        value: currency,
                        child: Text(
                          currency.name,
                          key: Key('currency_${currency.name}'),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
        validator: (val) {
          return (val == null)
              ? AppLocalizations.of(context)
                  .translate('form_currency_dropdown_error')
              : null;
        },
      ),
    );
  }
}
