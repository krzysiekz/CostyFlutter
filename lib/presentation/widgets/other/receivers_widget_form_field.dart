import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../data/models/user.dart';
import '../../../keys.dart';
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
          margin: const EdgeInsets.only(right: 5, left: 5),
          child: FormField<Iterable<User>>(
            initialValue: initialReceivers ?? state.users,
            builder: (FormFieldState<Iterable<User>> formState) {
              return InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0.0),
                    prefixIcon: Icon(
                      context.platformIcons.group,
                      color: Colors.blue,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    isDense: true,
                    errorText: formState.hasError ? formState.errorText : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  child: MultiSelectChip(
                    key: const Key(Keys.expenseFormReceiversFieldKey),
                    selectedUserList: initialReceivers ?? state.users,
                    userList: state.users,
                    onSelectionChanged: (Iterable<User> selected) {
                      formState.didChange(selected);
                      onSelectionChangedFunction(selected);
                    },
                    extractLabelFunction: (User u) => u.name,
                  ));
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
