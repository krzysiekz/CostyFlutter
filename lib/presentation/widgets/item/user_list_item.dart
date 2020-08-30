import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../data/models/project.dart';
import '../../../data/models/user.dart';
import '../../../style_constants.dart';
import '../../bloc/bloc.dart';
import '../forms/new_user_form_page.dart';
import '../utilities/dialog_utilities.dart';

class UserListItem extends StatefulWidget {
  final User user;
  final Project project;

  const UserListItem({Key key, @required this.user, @required this.project})
      : super(key: key);

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          buildBottomCard(),
          buildTopCard(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Text(widget.user.name,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: const TextStyle(
                      fontWeight: StyleConstants.primaryFontWeight,
                      color: StyleConstants.primaryTextColor,
                      fontSize: StyleConstants.secondaryTextSize,
                    )),
              ),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildDeleteButton(context),
                      buildEditButton(context)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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

  IconButton buildEditButton(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        icon:
            SvgPicture.asset('assets/images/edit.svg', semanticsLabel: 'Edit'),
        onPressed: () => _showEditUserForm(context, widget.project));
  }

  IconButton buildDeleteButton(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        icon: SvgPicture.asset('assets/images/delete.svg',
            semanticsLabel: 'Delete'),
        onPressed: () async {
          final bool result = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return DialogUtilities.createDeleteConfirmationDialog(context);
              });
          if (result) {
            BlocProvider.of<UserBloc>(context)
                .add(DeleteUserEvent(widget.user.id));
            BlocProvider.of<UserBloc>(context)
                .add(GetUsersEvent(widget.project));
          }
        });
  }

  void _showEditUserForm(BuildContext ctx, Project project) {
    NewUserForm.navigate(ctx, project, userToModify: widget.user);
  }
}
