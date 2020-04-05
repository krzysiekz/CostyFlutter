import 'package:costy/data/models/user.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../keys.dart';
import 'multi_select_chip.dart';

class ReceiversWidget extends StatelessWidget {
  final List<User> initialReceivers;
  final Function onSelectionChangedFunction;

  const ReceiversWidget(
      {Key key, this.initialReceivers, this.onSelectionChangedFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        bloc: BlocProvider.of<UserBloc>(context),
        builder: (context, state) {
          if (state is UserLoaded) {
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
                          color: IconTheme.of(context).color,
                        ),
                        filled: true,
                        fillColor: const Color.fromRGBO(235, 235, 235, 1),
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
                        initialUserList: initialReceivers,
                        userList: state.users,
                        onSelectionChanged: onSelectionChangedFunction,
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
