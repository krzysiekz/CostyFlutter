import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Projects'),
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
      backgroundColor: Colors.white,
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
              context, 'Error', 'Cannot add project.');
        } else if (state is ProjectAdded) {
          DialogUtilities.showSnackBar(context, "Project added.");
        } else if (state is ProjectDeleted) {
          DialogUtilities.showSnackBar(context, "Project deleted.");
        } else if (state is ProjectModified) {
          DialogUtilities.showSnackBar(context, "Project modified.");
        }
      },
      builder: (context, state) {
        if (state is ProjectEmpty) {
          return const Text("No projects to display.");
        } else if (state is ProjectLoaded) {
          if (state.projects.isEmpty) {
            return const Text("No projects to display.");
          }
          return ListView.builder(
            itemBuilder: (ctx, index) {
              return ProjectListItem(
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
