import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'data/datasources/currencies_datasource.dart';
import 'data/datasources/entities/currency_entity.dart';
import 'data/datasources/entities/project_entity.dart';
import 'data/datasources/entities/user_entity.dart';
import 'data/datasources/entities/user_expense_entity.dart';
import 'injection_container.dart' as di;
import 'presentation/pages/projects_page.dart';

const SUPPORTED_CURRENCIES = ['USD', 'EUR', 'PLN', 'GBP'];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(CurrencyEntityAdapter(), 0);
  Hive.registerAdapter(ProjectEntityAdapter(), 1);
  Hive.registerAdapter(UserEntityAdapter(), 2);
  Hive.registerAdapter(UserExpenseEntityAdapter(), 3);
  await initHiveStaticData();
  runApp(MyApp());
}

Future<void> initHiveStaticData() async {
  final currenciesDataSource = di.ic<CurrenciesDataSource>();
  final currencies = await currenciesDataSource.getCurrencies();
  if (currencies.isEmpty) {
    await currenciesDataSource.saveCurrencies(SUPPORTED_CURRENCIES);
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF296EB4),
        accentColor: Color(0xFFFDB833),
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
        backgroundColor: Color(0xFFFCEDCF),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
      home: SplashScreen.navigate(
          name: 'assets/costy_splash.flr',
          next: (_) => ProjectsPage(),
          until: () => Future.delayed(Duration(milliseconds: 500)),
          startAnimation: 'splash',
          backgroundColor: Color(0xFF296EB4)),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
