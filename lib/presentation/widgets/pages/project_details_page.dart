import 'package:costy/presentation/widgets/forms/new_expense_form.dart';
import 'package:flutter/material.dart';

import '../../../data/models/project.dart';
import '../forms/new_user_form.dart';
import 'expenses_list_page.dart';
import 'report_page.dart';
import 'user_list_page.dart';

class ProjectDetailsPage extends StatefulWidget {
  static const ROUTE_NAME = '/project-details';

  ProjectDetailsPage({Key key}) : super(key: key);

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  void _showAddUserForm(BuildContext ctx, Project project) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      context: ctx,
      builder: (_) {
        return NewUserForm(project: project);
      },
    );
  }

  void _showAddExpenseForm(BuildContext ctx, Project project) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      context: ctx,
      builder: (_) {
        return NewExpenseForm(project: project);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = ModalRoute.of(context).settings.arguments as Project;

    return buildProjectDetailsPage(project, context);
  }

  Container buildProjectDetailsPage(Project project, BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: Text(project.name),
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              color: Colors.transparent,
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    TabBar(
                      controller: _tabController,
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
                            width: 4.0,
                          ),
                          insets: EdgeInsets.symmetric(
                            horizontal: 60,
                          )),
                      indicatorWeight: 6,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Theme.of(context).accentColor,
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelColor: Colors.white38,
                      tabs: <Widget>[
                        const Tab(
                          text: "USERS",
                          icon: Icon(
                            Icons.people,
                            size: 35,
                          ),
                        ),
                        const Tab(
                          text: "EXPENSES",
                          icon: Icon(
                            Icons.attach_money,
                            size: 35,
                          ),
                        ),
                        const Tab(
                          text: "REPORT",
                          icon: Icon(
                            Icons.picture_as_pdf,
                            size: 35,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Center(child: UserListPage(project: project)),
            Center(child: ExpensesListPage(project: project)),
            Center(child: ReportPage(project: project)),
          ],
        ),
        floatingActionButton: _bottomButtons(project, context),
      ),
    );
  }

  Widget _bottomButtons(Project project, BuildContext ctx) {
    switch (_tabController.index) {
      case 0:
        return FloatingActionButton(
            onPressed: () => _showAddUserForm(ctx, project),
            child: const Icon(
              Icons.person_add,
            ));
      case 1:
        return FloatingActionButton(
          onPressed: () => _showAddExpenseForm(ctx, project),
          child: const Icon(
            Icons.note_add,
          ),
        );
      default:
        return null;
    }
  }
}
