import 'package:get_it/get_it.dart';

import 'data/datasources/currencies_datasource.dart';
import 'data/datasources/expenses_datasource.dart';
import 'data/datasources/hive_operations.dart';
import 'data/datasources/impl/currencies_datasource_impl.dart';
import 'data/datasources/impl/expenses_datasource_impl.dart';
import 'data/datasources/impl/hive_operations_impl.dart';
import 'data/datasources/impl/projects_datasource_impl.dart';
import 'data/datasources/impl/users_datasource_impl.dart';
import 'data/datasources/projects_datasource.dart';
import 'data/datasources/users_datasource.dart';
import 'data/repositories/currencies_repository.dart';
import 'data/repositories/expenses_repository.dart';
import 'data/repositories/impl/currencies_repository_impl.dart';
import 'data/repositories/impl/expenses_repository_impl.dart';
import 'data/repositories/impl/projects_repository_impl.dart';
import 'data/repositories/impl/users_repository_impl.dart';
import 'data/repositories/projects_repository.dart';
import 'data/repositories/users_repository.dart';
import 'data/services/impl/report_generator_impl.dart';
import 'data/services/report_generator.dart';
import 'data/usecases/impl/add_expense.dart';
import 'data/usecases/impl/add_project.dart';
import 'data/usecases/impl/add_user.dart';
import 'data/usecases/impl/delete_expense.dart';
import 'data/usecases/impl/delete_project.dart';
import 'data/usecases/impl/delete_user.dart';
import 'data/usecases/impl/get_currencies.dart';
import 'data/usecases/impl/get_expenses.dart';
import 'data/usecases/impl/get_projects.dart';
import 'data/usecases/impl/get_report.dart';
import 'data/usecases/impl/get_users.dart';
import 'data/usecases/impl/modify_expense.dart';
import 'data/usecases/impl/modify_project.dart';
import 'data/usecases/impl/modify_user.dart';
import 'presentation/bloc/bloc.dart';

final ic = GetIt.instance;

Future<void> init() async {
  registerBloc();
  registerUseCases();
  registerRepositories();
  registerDataSources();
  registerOtherClasses();
}

void registerOtherClasses() {
  ic.registerLazySingleton<ReportGenerator>(() => ReportGeneratorImpl());
  ic.registerLazySingleton<HiveOperations>(() => HiveOperationsImpl());
}

void registerDataSources() {
  ic.registerLazySingleton<CurrenciesDataSource>(
      () => CurrenciesDataSourceImpl(ic()));

  ic.registerLazySingleton<ProjectsDataSource>(
      () => ProjectsDataSourceImpl(ic()));

  ic.registerLazySingleton<UsersDataSource>(() => UsersDataSourceImpl(ic()));

  ic.registerLazySingleton<ExpensesDataSource>(
      () => ExpensesDataSourceImpl(ic()));
}

void registerRepositories() {
  ic.registerLazySingleton<CurrenciesRepository>(
      () => CurrenciesRepositoryImpl(ic()));

  ic.registerLazySingleton<ProjectsRepository>(
      () => ProjectsRepositoryImpl(ic()));

  ic.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(ic()));

  ic.registerLazySingleton<ExpensesRepository>(
      () => ExpensesRepositoryImpl(ic(), ic()));
}

void registerUseCases() {
  ic.registerLazySingleton(() => GetCurrencies(currenciesRepository: ic()));

  ic.registerLazySingleton(() => AddProject(projectsRepository: ic()));
  ic.registerLazySingleton(() => DeleteProject(projectsRepository: ic()));
  ic.registerLazySingleton(() => GetProjects(projectsRepository: ic()));
  ic.registerLazySingleton(() => ModifyProject(projectsRepository: ic()));

  ic.registerLazySingleton(() => AddUser(usersRepository: ic()));
  ic.registerLazySingleton(() => DeleteUser(usersRepository: ic()));
  ic.registerLazySingleton(() => GetUsers(usersRepository: ic()));
  ic.registerLazySingleton(() => ModifyUser(usersRepository: ic()));

  ic.registerLazySingleton(() => AddExpense(expensesRepository: ic()));
  ic.registerLazySingleton(() => DeleteExpense(expensesRepository: ic()));
  ic.registerLazySingleton(() => GetExpenses(expensesRepository: ic()));
  ic.registerLazySingleton(() => ModifyExpense(expensesRepository: ic()));

  ic.registerLazySingleton(() => GetReport(reportGenerator: ic()));
}

void registerBloc() {
  ic.registerFactory(() => CurrencyBloc(ic()));
  ic.registerFactory(() => ExpenseBloc(
      addExpense: ic(),
      deleteExpense: ic(),
      getExpenses: ic(),
      modifyExpense: ic()));
  ic.registerFactory(() => ProjectBloc(
      addProject: ic(),
      deleteProject: ic(),
      getProjects: ic(),
      modifyProject: ic()));
  ic.registerFactory(() => UserBloc(
      addUser: ic(), deleteUser: ic(), getUsers: ic(), modifyUser: ic()));
  ic.registerFactory(() => ReportBloc(ic(), ic()));
}
