import 'package:bloc_test/bloc_test.dart';
import 'package:core/src/blocs/budget_bloc.dart';
import 'package:core/src/entities/budget_period.dart';
import 'package:core/src/repository/budget_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockBudgetRepository extends Mock implements BudgetRepository {}

void main() {
  late BudgetManagerBloc budgetBloc;
  late MockBudgetRepository budgetRepository;

  group('BudgetBloc tests', () {
    setUp(() {
      registerFallbackValue(
          BudgetPeriod(start: DateTime.now(), end: DateTime.now()));
      budgetRepository = MockBudgetRepository();
      budgetBloc = BudgetManagerBloc(budgetRepository);
    });

    test('Initial state - Unintialized', () {
      expect(budgetBloc.state, isA<UninitializedBudget>());
    });

    blocTest("test", build: () => budgetBloc);

    test('Add a budget period', () async {
      final expectedStart = DateTime.parse("2022-01-01");
      final expectedEnd = DateTime.parse("2022-01-31");

      when(() =>
              budgetRepository.saveBudgetPeriod(any(that: isA<BudgetPeriod>())))
          .thenAnswer((_) => Future.value());

      budgetBloc.add(AddBudgetPeriod(start: expectedStart, end: expectedEnd));

      await Future.delayed(Duration.zero);

      expect(budgetBloc.state, isA<DetailedBudget>());
      var detailedBudget = (budgetBloc.state as DetailedBudget);
      expect(detailedBudget.period.start, equals(expectedStart));
      expect(detailedBudget.period.end, equals(expectedEnd));
      verify(() =>
              budgetRepository.saveBudgetPeriod(any(that: isA<BudgetPeriod>())))
          .called(1);
      verifyNoMoreInteractions(budgetRepository);
    });

    blocTest('Add a budget period with bloc test',
        build: () => BudgetManagerBloc(budgetRepository),
        setUp: () {
          when(() => budgetRepository
                  .saveBudgetPeriod(any(that: isA<BudgetPeriod>())))
              .thenAnswer((_) => Future.value());
        },
        act: (bloc) {
          final expectedStart = DateTime.parse("2022-01-01");
          final expectedEnd = DateTime.parse("2022-01-31");

          return bloc
              .add(AddBudgetPeriod(start: expectedStart, end: expectedEnd));
        },
        expect: () => [
              DetailedBudget(
                  period: BudgetPeriod(
                      start: DateTime.parse("2022-01-01"),
                      end: DateTime.parse("2022-01-31")))
            ],
        verify: (bloc) {
          verify(() => budgetRepository
              .saveBudgetPeriod(any(that: isA<BudgetPeriod>()))).called(1);
          verifyNoMoreInteractions(budgetRepository);
        });


    blocTest('Add a budget period with bloc test - should fail',
        build: () => BudgetManagerBloc(budgetRepository),
        setUp: () {
          when(() => budgetRepository
                  .saveBudgetPeriod(any(that: isA<BudgetPeriod>())))
              .thenAnswer((_) => Future.value());
        },
        act: (bloc) {
          final expectedStart = DateTime.parse("2022-01-01");
          final expectedEnd = DateTime.parse("2022-01-31");

          return bloc
              .add(AddBudgetPeriod(start: expectedStart, end: expectedEnd));
        },
        expect: () => [
              DetailedBudget(
                  period: BudgetPeriod(
                      start: DateTime.parse("2022-01-01"),
                      end: DateTime.parse("2023-01-31")))
            ],
        verify: (bloc) {
          verify(() => budgetRepository
              .saveBudgetPeriod(any(that: isA<BudgetPeriod>()))).called(1);
          verifyNoMoreInteractions(budgetRepository);
        });

  });
}
