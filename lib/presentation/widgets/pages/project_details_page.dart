import 'package:costy/data/models/project.dart';
import 'package:costy/presentation/widgets/pages/expenses_list_page.dart';
import 'package:costy/presentation/widgets/pages/person_list_page.dart';
import 'package:costy/presentation/widgets/pages/report_page.dart';
import 'package:flutter/material.dart';

class ProjectDetailsPage extends StatefulWidget {
  static const routeName = '/project-details';

  ProjectDetailsPage({Key key}) : super(key: key);

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  FloatingActionButton _addPersonButton;
  FloatingActionButton _addExpenseButton;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabIndex);

    _addPersonButton = FloatingActionButton(
        onPressed: null,
        child: Icon(
          Icons.person_add,
        ));

    _addExpenseButton = FloatingActionButton(
      onPressed: null,
      child: Icon(
        Icons.note_add,
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final project = ModalRoute.of(context).settings.arguments as Project;

    return Container(
      height: 600,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: Text(project.name),
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
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
                      labelStyle: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelColor: Colors.white38,
                      tabs: <Widget>[
                        Tab(
                          text: "PEOPLE",
                          icon: Icon(
                            Icons.people,
                            size: 35,
                          ),
                        ),
                        Tab(
                          text: "EXPENSES",
                          icon: Icon(
                            Icons.attach_money,
                            size: 35,
                          ),
                        ),
                        Tab(
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
            Center(child: PersonListPage()),
            Center(child: ExpensesListPage()),
            Center(child: ReportPage()),
          ],
        ),
        floatingActionButton: _bottomButtons(),
      ),
    );
  }

  Widget _bottomButtons() {
    switch (_tabController.index) {
      case 0:
        return _addPersonButton;
      case 1:
        return _addExpenseButton;
      default:
        return null;
    }
  }
}
