import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/currency.dart';
import '../../injection_container.dart';
import '../bloc/bloc.dart';
import '../widgets/new_project.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
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
      appBar: AppBar(
        title: Text('Projects'),
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
      body: SingleChildScrollView(child: buildBody(context)),
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
        return NewProject(_addNewProject);
      },
    );
  }

  BlocProvider<ProjectBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => _projectBloc,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              BlocBuilder<ProjectBloc, ProjectState>(
                builder: (context, state) {
                  if (state is ProjectEmpty) {
                    return Text("No projects to display.");
                  } else if (state is ProjectError) {
                    return Text("Cannot get projects.");
                  } else if (state is ProjectLoaded) {
                    return Text("Projects loaded.");
                  } else if (state is ProjectLoading) {
                    return Text("Projects loading.");
                  } else if (state is ProjectAdded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Project added."),
                      ));
                    });
                  }
                  return Container();
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
