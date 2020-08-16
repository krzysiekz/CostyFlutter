import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../../keys.dart';
import '../../bloc/bloc.dart';
import '../forms/new_expense_form_page.dart';
import '../forms/new_user_form_page.dart';
import '../utilities/dialog_utilities.dart';
import 'expenses_list_page.dart';
import 'report_page.dart';
import 'user_list_page.dart';

class ProjectDetailsPage extends StatefulWidget {
  static void navigate(BuildContext buildContext, Project project) {
    Navigator.of(buildContext).push(platformPageRoute(
      context: buildContext,
      builder: (BuildContext context) => ProjectDetailsPage(project: project),
    ));
  }

  final Project project;

  ProjectDetailsPage({Key key, this.project}) : super(key: key);

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage>
    with SingleTickerProviderStateMixin {
  PlatformTabController _tabController;

  final items = (BuildContext context) => [
        BottomNavigationBarItem(
          title: Text(
            AppLocalizations.of(context)
                .translate('project_details_page_users'),
            key: const Key(Keys.PROJECT_DETAILS_USERS_TAB),
          ),
          icon: Icon(context.platformIcons.group),
        ),
        BottomNavigationBarItem(
          title: Text(
            AppLocalizations.of(context)
                .translate('project_details_page_expenses'),
            key: const Key(Keys.PROJECT_DETAILS_EXPENSES_TAB),
          ),
          icon: Icon(context.platformIcons.shoppingCart),
        ),
        BottomNavigationBarItem(
          title: Text(
            AppLocalizations.of(context)
                .translate('project_details_page_report'),
            key: const Key(Keys.PROJECT_DETAILS_REPORT_TAB),
          ),
          icon: Icon(context.platformIcons.mail),
        ),
      ];

  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));
    _tabController = PlatformTabController(initialIndex: 1);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddUserForm(BuildContext ctx, Project project) {
    NewUserForm.navigate(ctx, project);
  }

  void _showAddExpenseForm(BuildContext ctx, Project project) {
    NewExpenseForm.navigate(ctx, project);
  }

  @override
  Widget build(BuildContext context) {
    return buildProjectDetailsPage(widget.project, context);
  }

  Widget buildProjectDetailsPage(Project project, BuildContext context) {
    return PlatformTabScaffold(
      iosContentPadding: true,
      tabController: _tabController,
      appBarBuilder: (_, index) => PlatformAppBar(
        title: Text(project.name),
        trailingActions: _actionButtons(project, context, index),
        cupertino: (_, platform) => CupertinoNavigationBarData(
            title: items(context)[index].title,
            leading: CupertinoNavigationBarBackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
            automaticallyImplyLeading: true),
        material: (_, platform) => MaterialAppBarData(elevation: 1),
      ),
      bodyBuilder: (context, index) => _body(project, context, index),
      items: items(context),
      materialTabs: (_, plaform) => MaterialNavBarData(elevation: 2),
      cupertinoTabs: (_, platform) =>
          CupertinoTabBarData(backgroundColor: CupertinoColors.white),
    );
  }

  List<Widget> _actionButtons(Project project, BuildContext ctx, int index) {
    switch (index) {
      case 0:
        return [
          PlatformIconButton(
            key: const Key(Keys.PROJECT_DETAILS_ADD_USER_BUTTON),
            onPressed: () => _showAddUserForm(ctx, project),
            icon: Icon(context.platformIcons.personAdd),
          )
        ];
      case 1:
        return [
          BlocBuilder<UserBloc, UserState>(
            builder: (BuildContext context, UserState state) {
              if (state is UserLoaded && state.users.isNotEmpty) {
                return PlatformIconButton(
                  key: const Key(Keys.PROJECT_DETAILS_ADD_EXPENSE_BUTTON),
                  onPressed: () => _showAddExpenseForm(ctx, project),
                  icon: Icon(context.platformIcons.add),
                );
              } else {
                return PlatformIconButton(
                  key: const Key(Keys.PROJECT_DETAILS_ADD_EXPENSE_BUTTON),
                  onPressed: () => DialogUtilities.showAlertDialog(
                      ctx,
                      AppLocalizations.of(context).translate('info'),
                      AppLocalizations.of(context)
                          .translate('expenses_list_page_no_users')),
                  icon: Icon(context.platformIcons.add),
                );
              }
            },
          )
        ];
      case 2:
        return [
          PlatformIconButton(
            onPressed: () => _shareReport(ctx, project),
            icon: Icon(context.platformIcons.share),
          )
        ];
      default:
        return null;
    }
  }

  Widget _body(Project project, BuildContext ctx, int index) {
    switch (index) {
      case 0:
        return Center(child: UserListPage(project: project));
      case 1:
        return Center(child: ExpensesListPage(project: project));
      case 2:
        return Center(child: ReportPage(project: project));
      default:
        return null;
    }
  }

  void _shareReport(BuildContext ctx, Project project) {
    BlocProvider.of<ReportBloc>(context).add(ShareReportEvent(project, ctx));
    BlocProvider.of<ReportBloc>(context).add(GetReportEvent(project));
  }
}
