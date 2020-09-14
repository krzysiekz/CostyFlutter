import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../data/models/user.dart';
import '../../../keys.dart';
import '../../../style_constants.dart';
import '../../bloc/bloc.dart';
import '../utilities/dialog_utilities.dart';
import 'multi_select_chip.dart';

class ReceiversWidgetFormField extends StatelessWidget {
  final List<User> initialReceivers;
  final Function onSelectionChangedFunction;

  const ReceiversWidgetFormField(
      {Key key, this.initialReceivers, this.onSelectionChangedFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserLoaded) {
        if (initialReceivers == null) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            onSelectionChangedFunction(state.users);
          });
          return DialogUtilities.showLoadingIndicator(context);
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FormField<Iterable<User>>(
            initialValue: initialReceivers ?? state.users,
            builder: (FormFieldState<Iterable<User>> formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocalizations.of(context)
                          .translate('expense_form_receivers_hint'),
                      style: const TextStyle(
                        fontWeight: StyleConstants.buttonsTextFontWeight,
                        color: StyleConstants.formLabelColor,
                        fontSize: StyleConstants.buttonsTextSize,
                      )),
                  InputDecorator(
                      decoration: InputDecoration(
                          isDense: true,
                          errorText:
                              formState.hasError ? formState.errorText : null,
                          border: InputBorder.none),
                      child: MultiSelectChip(
                        key: const Key(Keys.expenseFormReceiversFieldKey),
                        selectedUserList: initialReceivers ?? state.users,
                        userList: state.users,
                        onSelectionChanged: (Iterable<User> selected) {
                          formState.didChange(selected);
                          onSelectionChangedFunction(selected);
                        },
                        extractLabelFunction: (User u) => u.name,
                      )),
                ],
              );
            },
            validator: (val) {
              return (val == null || val.isEmpty)
                  ? AppLocalizations.of(context)
                      .translate('expense_form_receivers_error')
                  : null;
            },
          ),
        );
      }
      return Container();
    });
  }
}
