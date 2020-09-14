import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../data/models/currency.dart';
import '../../../data/models/project.dart';
import '../../../keys.dart';
import '../../../style_constants.dart';
import '../../bloc/bloc.dart';
import '../../bloc/currency_bloc.dart';
import '../../bloc/currency_state.dart';
import '../../bloc/project_bloc.dart';
import '../other/currency_dropdown_field.dart';

class NewProjectForm extends StatefulWidget {
  static void navigate(BuildContext buildContext, {Project projectToEdit}) {
    Navigator.of(buildContext).push(platformPageRoute(
      context: buildContext,
      builder: (BuildContext context) =>
          NewProjectForm(projectToEdit: projectToEdit),
    ));
  }

  final Project projectToEdit;

  const NewProjectForm({Key key, this.projectToEdit}) : super(key: key);

  @override
  _NewProjectFormState createState() => _NewProjectFormState();
}

class _NewProjectFormState extends State<NewProjectForm> {
  final _nameController = TextEditingController();
  Currency _defaultCurrency;

  final _formKey = GlobalKey<FormState>();

  void _submitData() {
    if (_formKey.currentState.validate()) {
      final enteredName = _nameController.text;

      if (widget.projectToEdit == null) {
        BlocProvider.of<ProjectBloc>(context).add(AddProjectEvent(
            projectName: enteredName, defaultCurrency: _defaultCurrency));
        BlocProvider.of<ProjectBloc>(context).add(GetProjectsEvent());
      } else {
        final Project edited = Project(
            id: widget.projectToEdit.id,
            name: enteredName,
            defaultCurrency: _defaultCurrency,
            creationDateTime: widget.projectToEdit.creationDateTime);
        BlocProvider.of<ProjectBloc>(context).add(ModifyProjectEvent(edited));
        BlocProvider.of<ProjectBloc>(context).add(GetProjectsEvent());
      }

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    if (widget.projectToEdit != null) {
      _nameController.text = widget.projectToEdit.name;
      _defaultCurrency = widget.projectToEdit.defaultCurrency;
    }
    BlocProvider.of<CurrencyBloc>(context).add(GetCurrenciesEvent());
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.projectToEdit == null
        ? AppLocalizations.of(context)
            .translate('project_form_add_project_button')
        : AppLocalizations.of(context)
            .translate('project_form_modify_project_button');
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
                      child: BlocBuilder<CurrencyBloc, CurrencyState>(
                          builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                            right: 10,
                            bottom: 10,
                          ),
                          child: _buildForm(context, state),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, CurrencyState state) {
    if (state is CurrencyLoaded) {
      return _showForm(context, state);
    } else {
      return Container();
    }
  }

  Widget _showForm(BuildContext context, CurrencyLoaded state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    AppLocalizations.of(context)
                        .translate('project_form_project_name_hint'),
                    style: const TextStyle(
                      fontWeight: StyleConstants.buttonsTextFontWeight,
                      color: StyleConstants.formLabelColor,
                      fontSize: StyleConstants.buttonsTextSize,
                    )),
                TextFormField(
                  key: const Key(Keys.projectFormProjectNameFieldKey),
                  controller: _nameController,
                  validator: (String val) => val.isEmpty
                      ? AppLocalizations.of(context)
                          .translate('project_form_project_name_error')
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          CurrencyDropdownField(
              key: const Key(Keys.projectFormDefaultCurrencyKey),
              initialValue: _defaultCurrency,
              currencies: state.currencies,
              callback: (Currency newValue) {
                setState(() {
                  _defaultCurrency = newValue;
                });
              }),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                key: const Key(Keys.projectFormCancelButtonKey),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                    AppLocalizations.of(context)
                        .translate('form_cancel_button'),
                    style: const TextStyle(
                      fontWeight: StyleConstants.buttonsTextFontWeight,
                      color: Colors.red,
                      fontSize: StyleConstants.buttonsTextSize,
                    )),
              ),
              FlatButton(
                key: const Key(Keys.projectFormAddEditButtonKey),
                onPressed: _submitData,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
                color: StyleConstants.primaryColor,
                child: Text(
                    widget.projectToEdit == null
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
