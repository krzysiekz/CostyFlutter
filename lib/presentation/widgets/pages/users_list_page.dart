import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../bloc/bloc.dart';
import '../../bloc/user_bloc.dart';
import '../forms/new_user_form_page.dart';
import '../item/user_list_item.dart';
import '../other/page_header.dart';
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
    return PageHeader(
      content: buildBody(),
      buttonOnPressed: () => _showAddUserForm(context, widget.project),
      svgAsset: 'assets/images/users.svg',
      title:
          AppLocalizations.of(context).translate('project_details_page_users'),
      description:
          AppLocalizations.of(context).translate('user_list_page_description'),
      buttonLabel: AppLocalizations.of(context).translate('add'),
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
