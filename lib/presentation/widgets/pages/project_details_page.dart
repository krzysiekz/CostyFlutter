import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../../keys.dart';
import '../../../style_constants.dart';
import '../../bloc/bloc.dart';
import 'expenses_list_page.dart';
import 'report_page.dart';
import 'users_list_page.dart';

class ProjectDetailsPage extends StatefulWidget {
  static void navigate(BuildContext buildContext, Project project) {
    Navigator.of(buildContext).push(MaterialPageRoute(
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
          Center(child: UsersListPage(project: project)),
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
                text: AppLocalizations.of(context)
                    .translate('project_details_page_users'),
                icon: const Icon(
                  FeatherIcons.users,
                  key: Key(Keys.projectDetailsUsersTab),
                ),
              ),
              Tab(
                text: AppLocalizations.of(context)
                    .translate('project_details_page_expenses'),
                icon: const Icon(
                  FeatherIcons.dollarSign,
                  key: Key(Keys.projectDetailsExpensesTab),
                ),
              ),
              Tab(
                text: AppLocalizations.of(context)
                    .translate('project_details_page_report'),
                icon: const Icon(
                  FeatherIcons.fileText,
                  key: Key(Keys.projectDetailsReportTab),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
