import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/currency.dart';
import '../../../injection_container.dart';
import '../../bloc/project_bloc.dart';
import '../../bloc/project_event.dart';
import '../../bloc/project_state.dart';
import '../forms/new_project_form.dart';
import '../other/project_list_item.dart';

class ProjectsListPage extends StatefulWidget {
  static const routeName = '/projects-list';

  @override
  _ProjectsListPageState createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends State<ProjectsListPage> {
  var _projectBloc;

  @override
  void initState() {
    _projectBloc = ic<ProjectBloc>();
    _projectBloc.add(GetProjectsEvent());
    super.initState();
  }

  @override
  void dispose() {
    _projectBloc.close();
    super.dispose();
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

  void _addNewProject(String projectName, String defaultCurrency) {
    _projectBloc.add(AddProjectEvent(
        projectName: projectName,
        defaultCurrency: Currency(name: defaultCurrency)));
    _projectBloc.add(GetProjectsEvent());
  }

  void _startAddNewProject(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewProjectForm(_addNewProject);
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return BlocConsumer<ProjectBloc, ProjectState>(
      bloc: _projectBloc,
      listener: (context, state) {
        if (state is ProjectError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showAlertDialog(context);
          });
        } else if (state is ProjectAdded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: const Text("Project added."),
            ));
          });
        }
      },
      builder: (context, state) {
        if (state is ProjectEmpty) {
          return Text("No projects to display.");
        } else if (state is ProjectLoaded) {
          return ListView.builder(
            itemBuilder: (ctx, index) {
              return ProjectListItem(
                project: state.projects[index],
              );
            },
            itemCount: state.projects.length,
          );
        } else if (state is ProjectLoading) {
          return _showLoadingIndicator(context);
        }
        return Container();
      },
    );
  }

  Column _showLoadingIndicator(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: 20,
            width: 20,
            margin: EdgeInsets.all(5),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Cannot fetch available currencies.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
