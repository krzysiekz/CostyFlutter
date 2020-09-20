import 'package:costy/presentation/widgets/other/form_cancel_button.dart';
import 'package:costy/presentation/widgets/other/form_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../../data/models/user.dart';
import '../../../keys.dart';
import '../../../style_constants.dart';
import '../../bloc/bloc.dart';
import '../../bloc/user_bloc.dart';

class NewPersonForm extends StatefulWidget {
  static void navigate(BuildContext buildContext, Project project,
      {User userToModify}) {
    Navigator.of(buildContext).push(MaterialPageRoute(
      builder: (BuildContext context) =>
          NewPersonForm(project: project, userToEdit: userToModify),
    ));
  }

  final Project project;
  final User userToEdit;

  const NewPersonForm({Key key, @required this.project, this.userToEdit})
      : super(key: key);

  @override
  _NewPersonFormState createState() => _NewPersonFormState();
}

class _NewPersonFormState extends State<NewPersonForm> {
  final _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.userToEdit != null) {
      _nameController.text = widget.userToEdit.name;
    }
    super.initState();
  }

  void _submitData() {
    if (_formKey.currentState.validate()) {
      final enteredName = _nameController.text;

      if (widget.userToEdit == null) {
        BlocProvider.of<UserBloc>(context)
            .add(AddUserEvent(enteredName, widget.project));
      } else {
        final User edited = User(id: widget.userToEdit.id, name: enteredName);
        BlocProvider.of<UserBloc>(context).add(ModifyUserEvent(edited));
      }

      BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.userToEdit == null
        ? AppLocalizations.of(context).translate('user_form_add_user_button')
        : AppLocalizations.of(context)
            .translate('user_form_modify_user_button');
    return Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
                  gradient: StyleConstants.primaryGradient)),
          Positioned.fill(
            top: 36,
            child: Column(
              children: [
                Text(title,
                    style: const TextStyle(
                      fontWeight: StyleConstants.formsTitleFontWeight,
                      color: StyleConstants.primaryTextColor,
                      fontSize: StyleConstants.formsTitleTextSize,
                    )),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: StyleConstants.backgroundColor),
                    child: SingleChildScrollView(
                        child: Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      child: _showForm(context),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _showForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FormTextField(
            controller: _nameController,
            hint: AppLocalizations.of(context)
                .translate('user_form_user_name_hint'),
            textFieldKey: Keys.userFormNameFieldKey,
            validator: (String val) => val.isEmpty
                ? AppLocalizations.of(context)
                    .translate('user_form_user_name_error')
                : null,
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const FormCancelButton(
                buttonKey: Keys.userFormCancelButtonKey,
              ),
              FlatButton(
                key: const Key(Keys.userFormAddEditButtonKey),
                onPressed: _submitData,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
                color: StyleConstants.primaryColor,
                child: Text(
                    widget.userToEdit == null
                        ? AppLocalizations.of(context).translate('add')
                        : AppLocalizations.of(context).translate('edit'),
                    style: const TextStyle(
                      fontWeight: StyleConstants.buttonsTextFontWeight,
                      color: Colors.white,
                      fontSize: StyleConstants.buttonsTextSize,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
