import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';

import '../../../data/models/project.dart';
import '../../bloc/bloc.dart';
import '../forms/new_project_form_page.dart';
import '../pages/project_details_page.dart';
import '../utilities/dialog_utilities.dart';

class ProjectListItem extends StatefulWidget {
  static final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");

  final Project project;

  ProjectListItem({Key key, this.project}) : super(key: key);

  @override
  _ProjectListItemState createState() => _ProjectListItemState();
}

class _ProjectListItemState extends State<ProjectListItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: DialogUtilities.createStackBehindDismiss(context),
      key: ObjectKey(widget.project),
      child: GestureDetector(
        onTap: () => ProjectDetailsPage.navigate(context, widget.project),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(10),
          child: ListTile(
            leading: Container(
              child: Text(widget.project.defaultCurrency.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            title: Text(widget.project.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Divider(thickness: 0.4),
                Text(ProjectListItem.dateFormat
                    .format(widget.project.creationDateTime)),
              ],
            ),
            trailing: GestureDetector(
              key: Key("${widget.project.id}_project_edit"),
              onTap: () => _startEditProject(context),
              child: Icon(
                context.platformIcons.create,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await showPlatformDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogUtilities.createDeleteConfirmationDialog(context);
          },
        );
      },
      onDismissed: (DismissDirection direction) {
        BlocProvider.of<ProjectBloc>(context)
            .add(DeleteProjectEvent(widget.project.id));
        BlocProvider.of<ProjectBloc>(context).add(GetProjectsEvent());
      },
    );
  }

  void _startEditProject(BuildContext ctx) {
    NewProjectForm.navigate(ctx, projectToEdit: widget.project);
  }
}
