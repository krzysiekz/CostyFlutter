import 'package:costy/data/models/user.dart';
import 'package:costy/keys.dart';
import 'package:costy/presentation/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../bloc/bloc.dart';
import '../../bloc/user_bloc.dart';

class NewUserForm extends StatefulWidget {
  final Project project;
  final User userToModify;

  const NewUserForm({Key key, @required this.project, this.userToModify})
      : super(key: key);

  @override
  _NewUserFormState createState() => _NewUserFormState();
}

class _NewUserFormState extends State<NewUserForm> {
  final _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.userToModify != null) {
      _nameController.text = widget.userToModify.name;
    }
    super.initState();
  }

  void _submitData() {
    if (_formKey.currentState.validate()) {
      final enteredName = _nameController.text;

      if (widget.userToModify == null) {
        BlocProvider.of<UserBloc>(context)
            .add(AddUserEvent(enteredName, widget.project));
      } else {
        final User edited = User(id: widget.userToModify.id, name: enteredName);
        BlocProvider.of<UserBloc>(context).add(ModifyUserEvent(edited));
      }

      BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
      elevation: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
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
            textFormFieldKey: Key(Keys.USER_FORM_NAME_FIELD_KEY),
            hintText: AppLocalizations.of(context)
                .translate('user_form_user_name_hint'),
            controller: _nameController,
            validator: (val) => val.isEmpty
                ? AppLocalizations.of(context)
                    .translate('user_form_user_name_error')
                : null,
            iconData: context.platformIcons.person,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              PlatformButton(
                androidFlat: (_) => MaterialFlatButtonData(
                  textColor: Theme.of(context).errorColor,
                ),
                key: Key(Keys.PROJECT_FORM_CANCEL_BUTTON_KEY),
                child: Text(AppLocalizations.of(context)
                    .translate('form_cancel_button')),
                onPressed: () => Navigator.of(context).pop(),
              ),
              PlatformButton(
                key: Key(Keys.USER_FORM_ADD_EDIT_BUTTON_KEY),
                child: widget.userToModify == null
                    ? Text(AppLocalizations.of(context)
                        .translate('user_form_add_user_button'))
                    : Text(AppLocalizations.of(context)
                        .translate('user_form_modify_user_button')),
                onPressed: _submitData,
              ),
            ],
          )
        ],
      ),
    );
  }
}
