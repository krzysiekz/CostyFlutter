import 'package:costy/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection_container.dart';

class ProjectsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
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
