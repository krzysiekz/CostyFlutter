import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../style_constants.dart';
import '../../bloc/project_bloc.dart';
import '../../bloc/project_event.dart';
import '../../bloc/project_state.dart';
import '../forms/new_project_form_page.dart';
import '../item/project_list_item.dart';
import '../other/page_header.dart';
import '../utilities/dialog_utilities.dart';

class ProjectsListPage extends StatefulWidget {
  @override
  _ProjectsListPageState createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends State<ProjectsListPage> {
  @override
  void initState() {
    BlocProvider.of<ProjectBloc>(context).add(GetProjectsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleConstants.backgroundColor,
      body: PageHeader(
        content: buildContent(),
        buttonOnPressed: () => _startAddNewProject(context),
        svgAsset: 'assets/images/grow.svg',
        title:
            AppLocalizations.of(context).translate('project_list_page_title'),
        description: AppLocalizations.of(context)
            .translate('project_list_page_description'),
        buttonLabel: AppLocalizations.of(context).translate('add'),
      ),
    );
  }

  BlocConsumer<ProjectBloc, ProjectState> buildContent() {
    return BlocConsumer<ProjectBloc, ProjectState>(listener: (context, state) {
      if (state is ProjectError) {
        DialogUtilities.showAlertDialog(
          context,
          AppLocalizations.of(context).translate('error'),
          AppLocalizations.of(context)
              .translate('project_list_page_cannot_add'),
        );
      } else if (state is ProjectAdded) {
        DialogUtilities.showSnackBar(context,
            AppLocalizations.of(context).translate('project_list_page_added'));
      } else if (state is ProjectDeleted) {
        DialogUtilities.showSnackBar(
            context,
            AppLocalizations.of(context)
                .translate('project_list_page_deleted'));
      } else if (state is ProjectModified) {
        DialogUtilities.showSnackBar(
            context,
            AppLocalizations.of(context)
                .translate('project_list_page_modified'));
      }
    }, builder: (context, state) {
      if (state is ProjectLoaded) {
        if (state.projects.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)
                .translate('project_list_page_no_projects')),
          );
        } else {
          return ListView.builder(
            itemCount: state.projects.length,
            itemBuilder: (ctx, index) => ProjectListItem(
              key: Key("project_${state.projects[index].id}"),
              project: state.projects[index],
            ),
          );
        }
      } else {
        return DialogUtilities.showLoadingIndicator(context);
      }
    });
  }

  void _startAddNewProject(BuildContext ctx) {
    NewProjectForm.navigate(ctx);
  }
}
