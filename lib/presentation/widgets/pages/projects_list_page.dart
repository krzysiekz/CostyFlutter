import 'package:costy/presentation/widgets/item/project_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../keys.dart';
import '../../bloc/project_bloc.dart';
import '../../bloc/project_event.dart';
import '../../bloc/project_state.dart';
import '../forms/new_project_form.dart';
import '../utilities/dialog_utilities.dart';

class ProjectsListPage extends StatefulWidget {
  @override
  _ProjectsListPageState createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends State<ProjectsListPage> {
  @override
  void initState() {
    BlocProvider.of<ProjectBloc>(context).add(GetProjectsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
//      appBar: PlatformAppBar(
//        title: Text(
//          AppLocalizations.of(context).translate('project_list_page_title'),
//        ),
//        trailingActions: <Widget>[
//          PlatformIconButton(
//            key: Key(Keys.PROJECT_LIST_ADD_PROJECT_BUTTON_KEY),
//            icon: Icon(Icons.add),
//            onPressed: () => _startAddNewProject(context),
//          )
//        ],
//      ),
      body: buildBody(context),
    );
  }

  void _startAddNewProject(BuildContext ctx) {
    showPlatformModalSheet(
      context: ctx,
      builder: (_) {
        return NewProjectForm();
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return BlocConsumer<ProjectBloc, ProjectState>(
      bloc: BlocProvider.of<ProjectBloc>(context),
      listener: (context, state) {
        if (state is ProjectError) {
          DialogUtilities.showAlertDialog(
            context,
            AppLocalizations.of(context).translate('error'),
            AppLocalizations.of(context)
                .translate('project_list_page_cannot_add'),
          );
        } else if (state is ProjectAdded) {
          DialogUtilities.showSnackBar(
              context,
              AppLocalizations.of(context)
                  .translate('project_list_page_added'));
        } else if (state is ProjectDeleted) {
          DialogUtilities.showSnackBar(
              context,
              AppLocalizations.of(context)
                  .translate('project_list_page_deleted'));
        } else if (state is ProjectModified) {
          DialogUtilities.showSnackBar(
              context,
              AppLocalizations.of(context)
                  .translate('project_list_page_modified'));
        }
      },
      builder: (context, state) {
        if (state is ProjectEmpty) {
          return Text(AppLocalizations.of(context)
              .translate('project_list_page_no_projects'));
        } else if (state is ProjectLoaded) {
          if (state.projects.isEmpty) {
            return Text(AppLocalizations.of(context)
                .translate('project_list_page_no_projects'));
          }
          return CustomScrollView(
            slivers: <Widget>[
              PlatformWidget(
                android: (context) => SliverAppBar(
                  actions: <Widget>[
                    PlatformIconButton(
                      key: Key(Keys.PROJECT_LIST_ADD_PROJECT_BUTTON_KEY),
                      icon: Icon(Icons.add),
                      onPressed: () => _startAddNewProject(context),
                    )
                  ],
                  expandedHeight: 120,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(AppLocalizations.of(context)
                        .translate('project_list_page_title')),
//                  background: Image.asset(
//                    '022.jpg',
//                    fit: BoxFit.cover,
//                  ),
                  ),
                ),
                ios: (context) => CupertinoSliverNavigationBar(
                  largeTitle: Text(AppLocalizations.of(context)
                      .translate('project_list_page_title')),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index >= state.projects.length) return null;
                    return ProjectListItem(
                      key: Key(state.projects[index].name),
                      project: state.projects[index],
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is ProjectLoading) {
          return DialogUtilities.showLoadingIndicator(context);
        }
        return Container();
      },
    );
  }
}
