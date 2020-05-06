import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oktoast/oktoast.dart';

import 'app_localizations.dart';
import 'data/datasources/currencies_datasource.dart';
import 'data/datasources/entities/currency_entity.dart';
import 'data/datasources/entities/project_entity.dart';
import 'data/datasources/entities/user_entity.dart';
import 'data/datasources/entities/user_expense_entity.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'presentation/bloc/bloc.dart';
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
  await Hive.initFlutter();
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
  AppBarTheme _appBarTheme() {
    return AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.blue,
      ),
    );
  }

  AppBarTheme _darkAppBarTheme() {
    return AppBarTheme(
      color: Color.fromRGBO(40, 40, 40, 1),
      iconTheme: IconThemeData(
        color: Colors.blue,
      ),
    );
  }

  ThemeData _buildLightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
        inputDecorationTheme: Theme.of(context)
            .inputDecorationTheme
            .copyWith(fillColor: Color.fromRGBO(235, 235, 235, 1)),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.blue),
        primaryTextTheme:
            Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.black),
        appBarTheme: _appBarTheme());
  }

  ThemeData _buildDarkTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
        inputDecorationTheme: Theme.of(context)
            .inputDecorationTheme
            .copyWith(fillColor: Color.fromRGBO(100, 100, 100, 1)),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.blue),
        primaryTextTheme:
            Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.white),
        appBarTheme: _darkAppBarTheme());
  }

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
            debugShowCheckedModeBanner: false,
            android: (_) => MaterialAppData(
              theme: _buildLightTheme(),
              darkTheme: _buildDarkTheme(),
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
