import 'package:bloc_test/bloc_test.dart';
import 'package:costy/app_localizations.dart';
import 'package:costy/data/models/currency.dart';
import 'package:costy/data/models/project.dart';
import 'package:costy/keys.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/pages/projects_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProjectBloc extends MockBloc<ProjectState> implements ProjectBloc {}

void main() {
  ProjectBloc projectBloc;
  Project tProject;

  Widget testedWidget;

  setUp(() {
    tProject = Project(
      id: 1,
      name: "Tested Project",
      defaultCurrency: const Currency(name: 'USD'),
      creationDateTime: DateTime.now(),
    );

    projectBloc = MockProjectBloc();

    //arrange
    when(projectBloc.state).thenAnswer(
      (_) => ProjectLoaded([tProject]),
    );

    testedWidget = BlocProvider(
      create: (_) => projectBloc,
      child: MaterialApp(
          locale: const Locale('en'),
          home: ProjectsListPage(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ]),
    );
  });

  tearDown(() {
    projectBloc.close();
  });

  testWidgets('should delete item if confirmed', (WidgetTester tester) async {
    await tester.runAsync(() async {
      //arrange
      await tester.pumpWidget(testedWidget);
      await tester.pumpAndSettle();

      final itemFinder = find.byType(Dismissible);
      final deleteButtonFinder =
          find.byKey(const Key(Keys.deleteConfirmationDeleteButton));
      //dismiss item
      expect(itemFinder, findsOneWidget);
      await tester.drag(itemFinder, const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      //verify popup
      expect(find.text('Are you sure you wish to delete this item?'),
          findsOneWidget);
      expect(deleteButtonFinder, findsOneWidget);

      //click delete
      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle();

      //assert
      verify(projectBloc.add(argThat(isA<GetProjectsEvent>())));
      verify(projectBloc.add(DeleteProjectEvent(tProject.id)));
    });
  });

  testWidgets('should not delete item if not confirmed',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      //arrange
      await tester.pumpWidget(testedWidget);
      await tester.pumpAndSettle();

      final itemFinder = find.byType(Dismissible);
      final cancelButtonFinder =
          find.byKey(const Key(Keys.deleteConfirmationCancelButton));
      //dismiss item
      expect(itemFinder, findsOneWidget);
      await tester.drag(itemFinder, const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      //verify popup
      expect(find.text('Are you sure you wish to delete this item?'),
          findsOneWidget);
      expect(cancelButtonFinder, findsOneWidget);

      //click delete
      await tester.tap(cancelButtonFinder);
      await tester.pumpAndSettle();

      //assert
      verify(projectBloc.add(argThat(isA<GetProjectsEvent>())));
      verifyNever(projectBloc.add(argThat(isA<DeleteProjectEvent>())));
    });
  });
}
