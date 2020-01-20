import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/project_bloc.dart';
import '../../bloc/project_event.dart';
import '../../bloc/project_state.dart';
import '../forms/new_project_form.dart';
import '../item/project_list_item.dart';
import '../utilities/dialog_utilities.dart';

class ProjectsListPage extends StatefulWidget {
  static const routeName = '/projects-list';

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
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewProject(context),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewProject(context),
      ),
      body: buildBody(context),
    );
  }

  void _startAddNewProject(BuildContext ctx) {
    showModalBottomSheet(
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
