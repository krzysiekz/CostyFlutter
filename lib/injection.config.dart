// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'data/usecases/impl/add_expense.dart';
import 'data/usecases/impl/add_project.dart';
import 'data/usecases/impl/add_user.dart';
import 'data/datasources/currencies_datasource.dart';
import 'data/datasources/impl/currencies_datasource_impl.dart';
import 'data/repositories/currencies_repository.dart';
import 'data/repositories/impl/currencies_repository_impl.dart';
import 'presentation/bloc/currency_bloc.dart';
import 'data/usecases/impl/delete_expense.dart';
import 'data/usecases/impl/delete_project.dart';
import 'data/usecases/impl/delete_user.dart';
import 'presentation/bloc/expense_bloc.dart';
import 'data/datasources/expenses_datasource.dart';
import 'data/datasources/impl/expenses_datasource_impl.dart';
import 'data/repositories/expenses_repository.dart';
import 'data/repositories/impl/expenses_repository_impl.dart';
import 'data/usecases/impl/get_currencies.dart';
import 'data/usecases/impl/get_expenses.dart';
import 'data/usecases/impl/get_projects.dart';
import 'data/usecases/impl/get_report.dart';
import 'data/usecases/impl/get_users.dart';
import 'data/datasources/hive_operations.dart';
import 'data/datasources/impl/hive_operations_impl.dart';
import 'data/usecases/impl/modify_expense.dart';
import 'data/usecases/impl/modify_project.dart';
import 'data/usecases/impl/modify_user.dart';
import 'presentation/bloc/project_bloc.dart';
import 'data/datasources/projects_datasource.dart';
import 'data/datasources/impl/projects_datasource_impl.dart';
import 'data/repositories/projects_repository.dart';
import 'data/repositories/impl/projects_repository_impl.dart';
import 'presentation/bloc/report_bloc.dart';
import 'data/services/report_formatter.dart';
import 'data/services/impl/report_formatter_impl.dart';
import 'data/services/report_generator.dart';
import 'data/services/impl/report_generator_impl.dart';
import 'data/usecases/impl/share_report.dart';
import 'presentation/bloc/user_bloc.dart';
import 'data/datasources/users_datasource.dart';
import 'data/datasources/impl/users_datasource_impl.dart';
import 'data/repositories/users_repository.dart';
import 'data/repositories/impl/users_repository_impl.dart';

/// Environment names
const _prod = 'prod';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);

  // Eager singletons must be registered in the right order
  gh.singleton<HiveOperations>(HiveOperationsImpl(), registerFor: {_prod});
  gh.singleton<ProjectsDataSource>(
      ProjectsDataSourceImpl(get<HiveOperations>()),
      registerFor: {_prod});
  gh.singleton<ProjectsRepository>(
      ProjectsRepositoryImpl(get<ProjectsDataSource>()),
      registerFor: {_prod});
  gh.singleton<ReportFormatter>(ReportFormatterImpl(), registerFor: {_prod});
  gh.singleton<ReportGenerator>(ReportGeneratorImpl(), registerFor: {_prod});
  gh.singleton<ShareReport>(
      ShareReport(
          reportFormatter: get<ReportFormatter>(),
          reportGenerator: get<ReportGenerator>()),
      registerFor: {_prod});
  gh.singleton<UsersDataSource>(UsersDataSourceImpl(get<HiveOperations>()),
      registerFor: {_prod});
  gh.singleton<UsersRepository>(UsersRepositoryImpl(get<UsersDataSource>()),
      registerFor: {_prod});
  gh.singleton<AddProject>(
      AddProject(projectsRepository: get<ProjectsRepository>()),
      registerFor: {_prod});
  gh.singleton<AddUser>(AddUser(usersRepository: get<UsersRepository>()),
      registerFor: {_prod});
  gh.singleton<CurrenciesDataSource>(
      CurrenciesDataSourceImpl(get<HiveOperations>()),
      registerFor: {_prod});
  gh.singleton<CurrenciesRepository>(
      CurrenciesRepositoryImpl(get<CurrenciesDataSource>()),
      registerFor: {_prod});
  gh.singleton<DeleteProject>(
      DeleteProject(projectsRepository: get<ProjectsRepository>()),
      registerFor: {_prod});
  gh.singleton<DeleteUser>(DeleteUser(usersRepository: get<UsersRepository>()),
      registerFor: {_prod});
  gh.singleton<ExpensesDataSource>(
      ExpensesDataSourceImpl(get<HiveOperations>()),
      registerFor: {_prod});
  gh.singleton<ExpensesRepository>(
      ExpensesRepositoryImpl(get<ExpensesDataSource>(), get<UsersDataSource>()),
      registerFor: {_prod});
  gh.singleton<GetCurrencies>(
      GetCurrencies(currenciesRepository: get<CurrenciesRepository>()),
      registerFor: {_prod});
  gh.singleton<GetExpenses>(
      GetExpenses(expensesRepository: get<ExpensesRepository>()),
      registerFor: {_prod});
  gh.singleton<GetProjects>(
      GetProjects(projectsRepository: get<ProjectsRepository>()),
      registerFor: {_prod});
  gh.singleton<GetReport>(GetReport(reportGenerator: get<ReportGenerator>()),
      registerFor: {_prod});
  gh.singleton<GetUsers>(GetUsers(usersRepository: get<UsersRepository>()),
      registerFor: {_prod});
  gh.singleton<ModifyExpense>(
      ModifyExpense(expensesRepository: get<ExpensesRepository>()),
      registerFor: {_prod});
  gh.singleton<ModifyProject>(
      ModifyProject(projectsRepository: get<ProjectsRepository>()),
      registerFor: {_prod});
  gh.singleton<ModifyUser>(ModifyUser(usersRepository: get<UsersRepository>()),
      registerFor: {_prod});
  gh.singleton<ProjectBloc>(
      ProjectBloc(
        getProjects: get<GetProjects>(),
        addProject: get<AddProject>(),
        modifyProject: get<ModifyProject>(),
        deleteProject: get<DeleteProject>(),
      ),
      registerFor: {_prod});
  gh.singleton<ReportBloc>(
      ReportBloc(
        get<GetReport>(),
        get<GetExpenses>(),
        get<ShareReport>(),
      ),
      registerFor: {_prod});
  gh.singleton<UserBloc>(
      UserBloc(
        getUsers: get<GetUsers>(),
        addUser: get<AddUser>(),
        modifyUser: get<ModifyUser>(),
        deleteUser: get<DeleteUser>(),
      ),
      registerFor: {_prod});
  gh.singleton<AddExpense>(
      AddExpense(expensesRepository: get<ExpensesRepository>()),
      registerFor: {_prod});
  gh.singleton<CurrencyBloc>(CurrencyBloc(get<GetCurrencies>()),
      registerFor: {_prod});
  gh.singleton<DeleteExpense>(
      DeleteExpense(expensesRepository: get<ExpensesRepository>()),
      registerFor: {_prod});
  gh.singleton<ExpenseBloc>(
      ExpenseBloc(
        addExpense: get<AddExpense>(),
        deleteExpense: get<DeleteExpense>(),
        modifyExpense: get<ModifyExpense>(),
        getExpenses: get<GetExpenses>(),
      ),
      registerFor: {_prod});
  return get;
}
