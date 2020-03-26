import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../keys.dart';
import '../../bloc/project_bloc.dart';
import '../../bloc/project_event.dart';
import '../../bloc/project_state.dart';
import '../forms/new_project_form.dart';
import '../item/project_list_item.dart';
import '../utilities/dialog_utilities.dart';

class ProjectsListPage extends StatefulWidget {
  static const ROUTE_NAME = '/projects-list';

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
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('project_list_page_title'),
        ),
        actions: <Widget>[
          IconButton(
            key: Key(Keys.PROJECT_LIST_ADD_PROJECT_BUTTON_KEY),
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewProject(context),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewProject(context),
      ),
      body: Center(child: buildBody(context)),
    );
  }

  void _startAddNewProject(BuildContext ctx) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      context: ctx,
      builder: (_) {
        return NewProjectForm();
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return BlocConsumer<ProjectBloc, ProjectState>(
      bloc: BlocProvider.of<ProjectBloc>(context),
      listener: (context, state) {
        if (state is ProjectError) {
          DialogUtilities.showAlertDialog(
            context,
            AppLocalizations.of(context).translate('error'),
            AppLocalizations.of(context)
                .translate('project_list_page_cannot_add'),
          );
        } else if (state is ProjectAdded) {
          DialogUtilities.showSnackBar(
              context,
              AppLocalizations.of(context)
                  .translate('project_list_page_added'));
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
      },
      builder: (context, state) {
        if (state is ProjectEmpty) {
          return Text(AppLocalizations.of(context)
              .translate('project_list_page_no_projects'));
        } else if (state is ProjectLoaded) {
          if (state.projects.isEmpty) {
            return Text(AppLocalizations.of(context)
                .translate('project_list_page_no_projects'));
          }
          return ListView.builder(
            itemBuilder: (ctx, index) {
              return ProjectListItem(
                key: Key(state.projects[index].name),
                project: state.projects[index],
              );
            },
            itemCount: state.projects.length,
          );
        } else if (state is ProjectLoading) {
          return DialogUtilities.showLoadingIndicator(context);
        }
        return Container();
      },
    );
  }
}
