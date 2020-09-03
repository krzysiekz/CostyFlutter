import 'dart:math';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../data/models/project.dart';
import '../../../style_constants.dart';
import '../../bloc/bloc.dart';
import '../forms/new_project_form_page.dart';
import '../pages/project_details_page.dart';
import '../utilities/dialog_utilities.dart';

class ProjectListItem extends StatefulWidget {
  static final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");

  final Project project;

  const ProjectListItem({Key key, this.project}) : super(key: key);

  @override
  _ProjectListItemState createState() => _ProjectListItemState();
}

class _ProjectListItemState extends State<ProjectListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ProjectDetailsPage.navigate(context, widget.project),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 2),
        child: Stack(
          children: [
            buildBottomCard(),
            buildTopCard(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildLeadingImage(),
                buildTextSection(),
                buildActionButtons(context)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildTopCard() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: StyleConstants.secondaryGradient),
    );
  }

  Transform buildBottomCard() {
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: StyleConstants.primaryGradient),
      ),
    );
  }

  Transform buildLeadingImage() {
    return Transform.translate(
      offset: const Offset(-10, -12),
      child:
          SvgPicture.asset('assets/images/globe.svg', semanticsLabel: 'Globe'),
    );
  }

  Expanded buildTextSection() {
    return Expanded(
      child: Transform.translate(
        offset: const Offset(0, -20),
        child: Column(
          children: [
            Text(widget.project.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: StyleConstants.primaryFontWeight,
                  color: StyleConstants.primaryTextColor,
                  fontSize: StyleConstants.secondaryTextSize,
                )),
            const SizedBox(
              height: 8,
            ),
            Text(
                ProjectListItem.dateFormat
                    .format(widget.project.creationDateTime),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: StyleConstants.primaryFontWeight,
                  color: StyleConstants.primaryTextColor,
                  fontSize: StyleConstants.descriptionTextSize,
                ))
          ],
        ),
      ),
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return Transform.translate(
      offset: const Offset(10, -20),
      child: Column(
        children: [
          buildDeleteButton(context),
          const SizedBox(
            height: 8,
          ),
          buildEditButton(context)
        ],
      ),
    );
  }

  IconButton buildEditButton(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        icon: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            FeatherIcons.edit3,
            color: StyleConstants.primaryColor,
          ),
        ),
        onPressed: () => _startEditProject(context));
  }

  IconButton buildDeleteButton(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        icon: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            FeatherIcons.trash2,
            color: Colors.red,
          ),
        ),
        onPressed: () async {
          final bool result = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return DialogUtilities.createDeleteConfirmationDialog(context);
              });
          if (result) {
            BlocProvider.of<ProjectBloc>(context)
                .add(DeleteProjectEvent(widget.project.id));
            BlocProvider.of<ProjectBloc>(context).add(GetProjectsEvent());
          }
        });
  }

  void _startEditProject(BuildContext ctx) {
    NewProjectForm.navigate(ctx, projectToEdit: widget.project);
  }
}
