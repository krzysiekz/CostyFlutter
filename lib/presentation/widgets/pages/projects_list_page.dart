import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../keys.dart';
import '../../bloc/project_bloc.dart';
import '../../bloc/project_event.dart';
import '../../bloc/project_state.dart';
import '../forms/new_project_form_page.dart';
import '../item/project_list_item.dart';
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
    NewProjectForm.navigate(ctx);
  }

  Widget buildBody(BuildContext context) {
    return BlocConsumer<ProjectBloc, ProjectState>(listener: (context, state) {
      if (state is ProjectError) {
        DialogUtilities.showAlertDialog(
          context,
          AppLocalizations.of(context).translate('error'),
          AppLocalizations.of(context)
              .translate('project_list_page_cannot_add'),
        );
      } else if (state is ProjectAdded) {
        DialogUtilities.showSnackBar(context,
            AppLocalizations.of(context).translate('project_list_page_added'));
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
    }, builder: (context, state) {
      if (state is ProjectLoaded) {
        return CustomScrollView(
          slivers: <Widget>[
            _createSliverAppBar(),
            _createRemainingSliverWidget(state),
          ],
        );
      } else {
        return DialogUtilities.showLoadingIndicator(context);
      }
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
            key: Key("project_${state.projects[index].id}"),
            project: state.projects[index],
          );
        },
      ),
    );
  }

  PlatformWidget _createSliverAppBar() {
    return PlatformWidget(
      material: (context, platform) => SliverAppBar(
        elevation: 1,
        actions: <Widget>[
          PlatformIconButton(
            key: const Key(Keys.projectlistAddProjectButtonKey),
            icon: Icon(context.platformIcons.add),
            onPressed: () => _startAddNewProject(context),
          )
        ],
        expandedHeight: 110,
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
        ),
      ),
      cupertino: (context, platform) => CupertinoSliverNavigationBar(
        backgroundColor: CupertinoColors.white,
        largeTitle: Text(
            AppLocalizations.of(context).translate('project_list_page_title')),
        trailing: PlatformIconButton(
          key: const Key(Keys.projectlistAddProjectButtonKey),
          icon: Icon(context.platformIcons.add),
          onPressed: () => _startAddNewProject(context),
        ),
      ),
    );
  }
}
