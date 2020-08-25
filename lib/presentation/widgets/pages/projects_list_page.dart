import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app_localizations.dart';
import '../../../keys.dart';
import '../../../style_constants.dart';
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
      backgroundColor: StyleConstants.backgroundColor,
      body: Column(
        children: [
          buildHeader(context),
          Expanded(child: buildContent()),
        ],
      ),
    );
  }

  BlocConsumer<ProjectBloc, ProjectState> buildContent() {
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
        return ListView.builder(
          itemCount: state.projects.length,
          itemBuilder: (ctx, index) => ProjectListItem(
            key: Key("project_${state.projects[index].id}"),
            project: state.projects[index],
          ),
        );
      } else {
        return DialogUtilities.showLoadingIndicator(context);
      }
    });
  }

  Stack buildHeader(BuildContext context) {
    return Stack(
      children: [
        buildHeaderBackground(),
        buildHeaderDescription(context),
      ],
    );
  }

  Padding buildHeaderDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 40),
      child: Wrap(
        direction: Axis.vertical, // make sure to set this
        spacing: 15, // set your spacing
        children: [
          Text(
              AppLocalizations.of(context).translate('project_list_page_title'),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: StyleConstants.primaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.primaryTextSize,
              )),
          Text(
              AppLocalizations.of(context)
                  .translate('project_list_page_description'),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: StyleConstants.secondaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.secondaryTextSize,
              )),
          FlatButton(
            onPressed: () => _startAddNewProject(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
            ),
            color: Colors.white,
            child: Text(AppLocalizations.of(context).translate('add'),
                style: const TextStyle(
                  fontWeight: StyleConstants.secondaryFontWeight,
                  color: Colors.black,
                  fontSize: StyleConstants.secondaryTextSize,
                )),
          ),
        ],
      ),
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
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                gradient: StyleConstants.primaryGradient),
          ),
          Positioned(
            bottom: -5,
            child: SvgPicture.asset('assets/images/grow.svg',
                semanticsLabel: 'Projects image'),
          )
        ]),
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
