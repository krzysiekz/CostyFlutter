import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../data/models/currency.dart';
import '../../../data/models/project.dart';
import '../../../keys.dart';
import '../../bloc/bloc.dart';
import '../../bloc/currency_bloc.dart';
import '../../bloc/currency_state.dart';
import '../../bloc/project_bloc.dart';
import '../other/currency_dropdown_field.dart';
import '../other/form_add_edit_button.dart';
import '../other/form_cancel_button.dart';
import '../other/form_decoration.dart';
import '../other/form_text_field.dart';

class NewProjectForm extends StatefulWidget {
  static void navigate(BuildContext buildContext, {Project projectToEdit}) {
    Navigator.of(buildContext).push(MaterialPageRoute(
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
      body: BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, state) {
        return FormDecoration(
            title: title, content: _buildForm(context, state));
      }),
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
          FormTextField(
            controller: _nameController,
            hint: AppLocalizations.of(context)
                .translate('project_form_project_name_hint'),
            textFieldKey: Keys.projectFormProjectNameFieldKey,
            validator: (String val) => val.isEmpty
                ? AppLocalizations.of(context)
                    .translate('project_form_project_name_error')
                : null,
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
              const FormCancelButton(
                buttonKey: Keys.projectFormCancelButtonKey,
              ),
              FormAddEditButton(
                key: const Key(Keys.projectFormAddEditButtonKey),
                onPressed: _submitData,
                isEdit: widget.projectToEdit != null,
              ),
            ],
          )
        ],
      ),
    );
  }
}
