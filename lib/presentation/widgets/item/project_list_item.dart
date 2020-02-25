import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/forms/new_project_form.dart';
import 'package:costy/presentation/widgets/utilities/dialog_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../data/models/project.dart';
import '../pages/project_details_page.dart';

class ProjectListItem extends StatefulWidget {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");

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
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          ProjectDetailsPage.ROUTE_NAME,
          arguments: widget.project,
        ),
        child: Card(
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  _buildProjectBackground(),
                  _buildProjectTitle(),
                  _buildEditButton(context),
                ],
              ),
              _buildProjectPropertiesPreview(),
            ],
          ),
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
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

  Padding _buildProjectPropertiesPreview() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildDefaultCurrencyPreview(),
          _buildCreationDateTimePreview(),
        ],
      ),
    );
  }

  Row _buildCreationDateTimePreview() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.date_range,
          color: Colors.white54,
        ),
        SizedBox(
          width: 6,
        ),
        Text(
          widget.dateFormat.format(widget.project.creationDateTime),
          style: TextStyle(color: Colors.white54, fontSize: 20),
        ),
      ],
    );
  }

  Row _buildDefaultCurrencyPreview() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.monetization_on,
          color: Colors.white54,
        ),
        SizedBox(
          width: 6,
        ),
        Text(
          widget.project.defaultCurrency.name,
          style: TextStyle(color: Colors.white70, fontSize: 20),
        ),
      ],
    );
  }

  ClipRRect _buildProjectBackground() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: Image.asset(
        'assets/project.jpg',
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Positioned _buildProjectTitle() {
    return Positioned(
      bottom: 20,
      right: 10,
      child: Container(
        width: 300,
        color: Colors.white70,
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 20,
        ),
        child: Text(
          widget.project.name,
          style: TextStyle(
            fontSize: 26,
            color: Colors.black,
          ),
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }

  Positioned _buildEditButton(BuildContext context) {
    return Positioned(
      key: Key("${widget.project.name}_edit"),
      top: 20,
      right: 10,
      child: GestureDetector(
        onTap: () => _startEditProject(context),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.edit,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }

  void _startEditProject(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      context: ctx,
      builder: (_) {
        return NewProjectForm(projectToEdit: widget.project);
      },
    );
  }
}
