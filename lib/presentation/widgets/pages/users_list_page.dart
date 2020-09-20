import 'dart:math';

import 'package:costy/presentation/widgets/forms/new_user_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../../keys.dart';
import '../../../style_constants.dart';
import '../../bloc/bloc.dart';
import '../../bloc/user_bloc.dart';
import '../item/user_list_item.dart';
import '../utilities/dialog_utilities.dart';

class UsersListPage extends StatefulWidget {
  final Project project;

  const UsersListPage({Key key, @required this.project}) : super(key: key);

  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRect(child: buildHeader(context)),
        Expanded(child: buildBody()),
      ],
    );
  }

  Stack buildHeader(BuildContext context) {
    return Stack(
      children: [
        buildHeaderBackground(),
        Positioned(
          top: 50,
          left: 20,
          child: SvgPicture.asset('assets/images/users.svg',
              semanticsLabel: 'Projects image'),
        ),
        Positioned(top: 40, right: 20, child: buildHeaderDescription(context)),
      ],
    );
  }

  Transform buildHeaderBackground() {
    return Transform.translate(
      offset: const Offset(0, -80),
      child: Transform.scale(
        scale: 1.2,
        child: Stack(
          children: [
            buildBottomCard(),
            buildTopCard(),
          ],
        ),
      ),
    );
  }

  Transform buildTopCard() {
    return Transform.translate(
      offset: const Offset(30, 0),
      child: Transform.rotate(
        angle: -15 * pi / 180,
        child: Container(
          height: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              gradient: StyleConstants.primaryGradient),
        ),
      ),
    );
  }

  Transform buildBottomCard() {
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            gradient: StyleConstants.secondaryGradient),
      ),
    );
  }

  Widget buildHeaderDescription(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 15,
      children: [
        Text(
            AppLocalizations.of(context)
                .translate('project_details_page_users'),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: StyleConstants.primaryFontWeight,
              color: StyleConstants.primaryTextColor,
              fontSize: StyleConstants.primaryTextSize,
            )),
        Text(
            AppLocalizations.of(context)
                .translate('user_list_page_description'),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: StyleConstants.secondaryFontWeight,
              color: StyleConstants.primaryTextColor,
              fontSize: StyleConstants.secondaryTextSize,
            )),
        FlatButton(
          key: const Key(Keys.projectDetailsAddUserButton),
          onPressed: () => _showAddUserForm(context, widget.project),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          color: Colors.white,
          child: Text(AppLocalizations.of(context).translate('add'),
              style: const TextStyle(
                fontWeight: StyleConstants.buttonsTextFontWeight,
                color: Colors.black,
                fontSize: StyleConstants.buttonsTextSize,
              )),
        ),
      ],
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: BlocConsumer<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
          if (state is UserEmpty) {
            return Text(AppLocalizations.of(context)
                .translate('user_list_page_no_users'));
          } else if (state is UserLoaded) {
            if (state.users.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)
                    .translate('user_list_page_no_users')),
              );
            }
            return GridView.builder(
              padding: const EdgeInsetsDirectional.only(bottom: 15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 25,
                  childAspectRatio: 1.9),
              itemBuilder: (cts, index) {
                return UserListItem(
                  key: Key("user_${state.users[index].id}"),
                  user: state.users[index],
                  project: widget.project,
                );
              },
              itemCount: state.users.length,
            );
          } else if (state is UserLoading) {
            return DialogUtilities.showLoadingIndicator(context);
          }
          return Container();
        },
        listener: (BuildContext context, UserState state) {
          if (state is UserError) {
            DialogUtilities.showAlertDialog(
                context,
                AppLocalizations.of(context).translate('error'),
                AppLocalizations.of(context)
                    .translate('user_list_page_cannot_add'));
          } else if (state is UserAdded) {
            DialogUtilities.showSnackBar(context,
                AppLocalizations.of(context).translate('user_list_page_added'));
          } else if (state is UserDeleted) {
            DialogUtilities.showSnackBar(
                context,
                AppLocalizations.of(context)
                    .translate('user_list_page_deleted'));
          } else if (state is UserModified) {
            DialogUtilities.showSnackBar(
                context,
                AppLocalizations.of(context)
                    .translate('user_list_page_modified'));
          }
        },
      ),
    );
  }

  void _showAddUserForm(BuildContext ctx, Project project) {
    NewPersonForm.navigate(ctx, project);
  }
}
