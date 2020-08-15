import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../../keys.dart';
import '../../bloc/bloc.dart';
import '../../bloc/currency_bloc.dart';
import '../../bloc/currency_state.dart';
import '../../bloc/project_bloc.dart';
import '../other/currency_dropdown_field.dart';
import '../other/custom_scaffold.dart';
import '../other/custom_text_field.dart';

class NewProjectForm extends StatefulWidget {
  static navigate(BuildContext buildContext, {Project projectToEdit}) {
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
  var _defaultCurrency;

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
    return CustomScaffold(
      appBarTitle: title,
      body: SingleChildScrollView(
        child: BlocBuilder<CurrencyBloc, CurrencyState>(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: _buildForm(context, state),
              );
            }),
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
          CustomTextField(
            textFormFieldKey: Key(Keys.PROJECT_FORM_PROJECT_NAME_FIELD_KEY),
            hintText: AppLocalizations.of(context)
                .translate('project_form_project_name_hint'),
            controller: _nameController,
            validator: (val) => val.isEmpty
                ? AppLocalizations.of(context)
                    .translate('project_form_project_name_error')
                : null,
            iconData: context.platformIcons.book,
          ),
          const SizedBox(
            height: 10,
          ),
          CurrencyDropdownField(
              key: Key(Keys.PROJECT_FORM_DEFAULT_CURRENCY_KEY),
              initialValue: _defaultCurrency,
              currencies: state.currencies,
              callback: (newValue) {
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
              PlatformButton(
                androidFlat: (_) => MaterialFlatButtonData(
                  textColor: Theme.of(context).errorColor,
                ),
                key: Key(Keys.PROJECT_FORM_CANCEL_BUTTON_KEY),
                child: Text(AppLocalizations.of(context)
                    .translate('form_cancel_button')),
                onPressed: () => Navigator.of(context).pop(),
                ios: (_) => CupertinoButtonData(),
              ),
              PlatformButton(
                key: Key(Keys.PROJECT_FORM_ADD_EDIT_BUTTON_KEY),
                child: widget.projectToEdit == null
                    ? Text(AppLocalizations.of(context)
                        .translate('project_form_add_project_button'))
                    : Text(AppLocalizations.of(context)
                        .translate('project_form_modify_project_button')),
                onPressed: _submitData,
              ),
            ],
          )
        ],
      ),
    );
  }
}
