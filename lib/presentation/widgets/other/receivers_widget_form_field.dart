import 'package:costy/data/models/user.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/utilities/dialog_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../keys.dart';
import 'multi_select_chip.dart';

class ReceiversWidgetFormField extends StatelessWidget {
  final List<User> initialReceivers;
  final Function onSelectionChangedFunction;

  const ReceiversWidgetFormField(
      {Key key, this.initialReceivers, this.onSelectionChangedFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        bloc: BlocProvider.of<UserBloc>(context),
        builder: (context, state) {
          if (state is UserLoaded) {
            if (initialReceivers == null) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                onSelectionChangedFunction(state.users);
              });
              return DialogUtilities.showLoadingIndicator(context);
            }

            return Container(
              margin: const EdgeInsets.only(right: 5, left: 5),
              child: FormField<List<User>>(
                initialValue:
                    initialReceivers == null ? state.users : initialReceivers,
                builder: (FormFieldState<List<User>> formState) {
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
                        errorText:
                            formState.hasError ? formState.errorText : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      child: MultiSelectChip(
                        key: Key(Keys.EXPENSE_FORM_RECEIVERS_FIELD_KEY),
                        selectedUserList: initialReceivers == null
                            ? state.users
                            : initialReceivers,
                        userList: state.users,
                        onSelectionChanged: (selected) {
                          formState.didChange(selected);
                          onSelectionChangedFunction(selected);
                        },
                        extractLabelFunction: (User u) => u.name,
                      ));
                },
                validator: (val) {
                  return (val == null || val.length < 1)
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
