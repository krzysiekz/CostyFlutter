import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../../keys.dart';
import '../../../style_constants.dart';
import '../../bloc/bloc.dart';
import 'expenses_list_page.dart';
import 'report_page.dart';
import 'people_list_page.dart';

class ProjectDetailsPage extends StatefulWidget {
  static void navigate(BuildContext buildContext, Project project) {
    Navigator.of(buildContext).push(platformPageRoute(
      context: buildContext,
      builder: (BuildContext context) => ProjectDetailsPage(project: project),
    ));
  }

  final Project project;

  const ProjectDetailsPage({Key key, this.project}) : super(key: key);

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {

  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildProjectDetailsPage(widget.project, context);
  }

  Widget buildProjectDetailsPage(Project project, BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: StyleConstants.backgroundColor,
        body: TabBarView(children: [
          Center(child: PeopleListPage(project: project)),
          Center(child: ExpensesListPage(project: project)),
          Center(child: ReportPage(project: project)),
        ]),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                offset: Offset(0.0, 1.0),
              )
            ],
          ),
          child: TabBar(
            labelColor: StyleConstants.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3.0,
                color: StyleConstants.primaryColor,
              ),
              insets: EdgeInsets.symmetric(horizontal: 5.0),
            ),
            tabs: [
              Tab(
                key: const Key(Keys.projectDetailsUsersTab),
                text: AppLocalizations.of(context)
                    .translate('project_details_page_users'),
                icon: const Icon(FeatherIcons.users),
              ),
              Tab(
                key: const Key(Keys.projectDetailsExpensesTab),
                text: AppLocalizations.of(context)
                    .translate('project_details_page_expenses'),
                icon: const Icon(FeatherIcons.dollarSign),
              ),
              Tab(
                key: const Key(Keys.projectDetailsReportTab),
                text: AppLocalizations.of(context)
                    .translate('project_details_page_report'),
                icon: const Icon(FeatherIcons.fileText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // List<Widget> _actionButtons(Project project, BuildContext ctx, int index) {
  //   switch (index) {
  //     case 0:
  //       return [
  //         PlatformIconButton(
  //           key: const Key(Keys.projectDetailsAddUserButton),
  //           onPressed: () => _showAddUserForm(ctx, project),
  //           icon: Icon(context.platformIcons.personAdd),
  //         )
  //       ];
  //     case 1:
  //       return [
  //         BlocBuilder<UserBloc, UserState>(
  //           builder: (BuildContext context, UserState state) {
  //             if (state is UserLoaded && state.users.isNotEmpty) {
  //               return PlatformIconButton(
  //                 key: const Key(Keys.projectDetailsAddExpenseButton),
  //                 onPressed: () => _showAddExpenseForm(ctx, project),
  //                 icon: Icon(context.platformIcons.add),
  //               );
  //             } else {
  //               return PlatformIconButton(
  //                 key: const Key(Keys.projectDetailsAddExpenseButton),
  //                 onPressed: () => DialogUtilities.showAlertDialog(
  //                     ctx,
  //                     AppLocalizations.of(context).translate('info'),
  //                     AppLocalizations.of(context)
  //                         .translate('expenses_list_page_no_users')),
  //                 icon: Icon(context.platformIcons.add),
  //               );
  //             }
  //           },
  //         )
  //       ];
  //     case 2:
  //       return [
  //         PlatformIconButton(
  //           onPressed: () => _shareReport(ctx, project),
  //           icon: Icon(context.platformIcons.share),
  //         )
  //       ];
  //     default:
  //       return null;
  //   }
  // }

  // Widget _body(Project project, BuildContext ctx, int index) {
  //   switch (index) {
  //     case 0:
  //       return Center(child: UserListPage(project: project));
  //     case 1:
  //       return Center(child: ExpensesListPage(project: project));
  //     case 2:
  //       return Center(child: ReportPage(project: project));
  //     default:
  //       return null;
  //   }
  // }

  // void _shareReport(BuildContext ctx, Project project) {
  //   BlocProvider.of<ReportBloc>(context).add(ShareReportEvent(project, ctx));
  //   BlocProvider.of<ReportBloc>(context).add(GetReportEvent(project));
  // }
}
