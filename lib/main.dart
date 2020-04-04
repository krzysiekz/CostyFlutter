import 'package:costy/presentation/bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'app_localizations.dart';
import 'data/datasources/currencies_datasource.dart';
import 'data/datasources/entities/currency_entity.dart';
import 'data/datasources/entities/project_entity.dart';
import 'data/datasources/entities/user_entity.dart';
import 'data/datasources/entities/user_expense_entity.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'presentation/widgets/pages/projects_list_page.dart';

const SUPPORTED_CURRENCIES = ['USD', 'EUR', 'PLN', 'GBP'];

Future<void> main() async {
  await initializeApp();
  runApp(DevicePreview(
    enabled: false,
    builder: (context) => MyApp(),
  ));
}

Future initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(CurrencyEntityAdapter());
  Hive.registerAdapter(ProjectEntityAdapter());
  Hive.registerAdapter(UserEntityAdapter());
  Hive.registerAdapter(UserExpenseEntityAdapter());
  await _initHiveStaticData();
}

Future<void> _initHiveStaticData() async {
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
    return MultiBlocProvider(
        providers: [
          BlocProvider<ProjectBloc>(
            create: (BuildContext context) => ic<ProjectBloc>(),
          ),
          BlocProvider<CurrencyBloc>(
            create: (BuildContext context) => ic<CurrencyBloc>(),
          ),
          BlocProvider<UserBloc>(
            create: (BuildContext context) => ic<UserBloc>(),
          ),
          BlocProvider<ExpenseBloc>(
            create: (BuildContext context) => ic<ExpenseBloc>(),
          ),
          BlocProvider<ReportBloc>(
            create: (BuildContext context) => ic<ReportBloc>(),
          ),
        ],
        child: OKToast(
          child: PlatformApp(
            android: (_) => MaterialAppData(
              theme: ThemeData.light().copyWith(
                  primaryColor: Colors.indigo,
                  iconTheme: ThemeData.light()
                      .iconTheme
                      .copyWith(color: Colors.indigoAccent),
                  buttonTheme: ButtonThemeData(
                    buttonColor: Colors.indigoAccent,
                    textTheme: ButtonTextTheme.primary,
                  )),
//              darkTheme: ThemeData.dark(),
            ),
            locale: DevicePreview.of(context).locale,
            builder: DevicePreview.appBuilder,
            title: 'Costy',
            supportedLocales: [
              Locale('en', 'US'),
              Locale('pl', 'PL'),
            ],
            // These delegates make sure that the localization data for the proper language is loaded
            localizationsDelegates: [
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
            ],
            // Returns a locale which will be used by the app
            localeResolutionCallback: (locale, supportedLocales) {
              // Check if the current device locale is supported
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              // If the locale of the device is not supported, use the first one
              // from the list (English, in this case).
              return supportedLocales.first;
            },
            home: ProjectsListPage(),
          ),
        ));
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
