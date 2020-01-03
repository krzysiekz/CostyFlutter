import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection_container.dart';
import '../bloc/bloc.dart';
import '../widgets/new_project.dart';

class ProjectsPage extends StatelessWidget {
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

  void _addNewProject(String projectName, String defaultCurrency) {}

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
      create: (_) => ic<ProjectBloc>(),
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
                  }
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
