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
          if (state is ProjectLoaded) {
            return CustomScrollView(
              slivers: <Widget>[
                _createSliverAppBar(),
                _createRemainingSliverWidget(state),
              ],
            );
          } else
            return DialogUtilities.showLoadingIndicator(context);
        });
  }

  Widget _createRemainingSliverWidget(ProjectLoaded state) {
    if (state.projects.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(AppLocalizations.of(context)
              .translate('project_list_page_no_projects')),
        ),
      );
    } else {
      return _createSliverList(state);
    }
  }

  SliverList _createSliverList(ProjectLoaded state) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index >= state.projects.length) return null;
          return ProjectListItem(
            key: Key(state.projects[index].name),
            project: state.projects[index],
          );
        },
      ),
    );
  }

  PlatformWidget _createSliverAppBar() {
    return PlatformWidget(
      android: (context) => SliverAppBar(
        actions: <Widget>[
          PlatformIconButton(
            key: Key(Keys.PROJECT_LIST_ADD_PROJECT_BUTTON_KEY),
            icon: Icon(context.platformIcons.add),
            onPressed: () => _startAddNewProject(context),
          )
        ],
        expandedHeight: 170,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          title: Container(
            padding: const EdgeInsets.all(5.0),
            child: Text(
                AppLocalizations.of(context)
                    .translate('project_list_page_title'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          background: Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      ios: (context) => CupertinoSliverNavigationBar(
        largeTitle: Text(
            AppLocalizations.of(context).translate('project_list_page_title')),
        trailing: PlatformIconButton(
          key: Key(Keys.PROJECT_LIST_ADD_PROJECT_BUTTON_KEY),
          icon: Icon(context.platformIcons.add),
          onPressed: () => _startAddNewProject(context),
        ),
      ),
    );
  }
}
