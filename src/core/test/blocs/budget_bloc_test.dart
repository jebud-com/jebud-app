@Timeout(Duration(seconds: 10))

import 'package:bloc_test/bloc_test.dart';
import 'package:core/src/blocs/budget_bloc.dart';
import 'package:core/src/entities/budget_period.dart';
import 'package:core/src/entities/period_income.dart';
import 'package:core/src/repository/budget_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockBudgetRepository extends Mock implements BudgetRepository {}

void main() {
  late BudgetManagerBloc budgetBloc;
  late MockBudgetRepository budgetRepository;

  final BudgetPeriod existingBudgetPeriod = BudgetPeriod(
      start: DateTime.parse("2022-01-01"), end: DateTime.parse("2022-01-31"));

  final PeriodIncome exitingPeriodIncome = PeriodIncome(amount: 2400);

  group('BudgetBloc tests', () {
    setUp(() {
      registerFallbackValue(PeriodIncome(amount: 0));
      registerFallbackValue(
          BudgetPeriod(start: DateTime.now(), end: DateTime.now()));
      budgetRepository = MockBudgetRepository();
      budgetBloc = BudgetManagerBloc(budgetRepository);
    });

    test('Initial state - Unintialized', () {
      expect(budgetBloc.state, isA<UninitializedBudget>());
    });

    final expectedStart = DateTime.parse("2022-01-01");
    final expectedEnd = DateTime.parse("2022-01-31");
    blocTest('Add a budget period with bloc test',
        build: () => BudgetManagerBloc(budgetRepository),
        setUp: () {
          when(() => budgetRepository
                  .saveBudgetPeriod(any(that: isA<BudgetPeriod>())))
              .thenAnswer((_) => Future.value());
        },
        act: (bloc) =>
            bloc.add(AddBudgetPeriod(start: expectedStart, end: expectedEnd)),
        expect: () => [
              isA<InitializingBudget>(),
              DetailedBudget(
                  period: BudgetPeriod(start: expectedStart, end: expectedEnd))
            ],
        verify: (bloc) {
          verify(() => budgetRepository.saveBudgetPeriod(
              BudgetPeriod(start: expectedStart, end: expectedEnd))).called(1);
          verifyNoMoreInteractions(budgetRepository);
        });

    blocTest<BudgetManagerBloc, BudgetManagerBlocState>(
        'Add first budget period income',
        build: () => BudgetManagerBloc(budgetRepository),
        setUp: () {
          when(() => budgetRepository
                  .addPeriodIncome(any(that: isA<PeriodIncome>())))
              .thenAnswer((_) => Future.value());
        },
        act: (bloc) => bloc.add(AddPeriodIncome(amount: 2400)),
        seed: () => DetailedBudget(period: existingBudgetPeriod),
        expect: () => [
              DetailedBudget(
                  period: existingBudgetPeriod, isAddingIncome: true),
              DetailedBudget(
                  period: existingBudgetPeriod,
                  incomes: [PeriodIncome(amount: 2400)],
                  isAddingIncome: false)
            ],
        verify: (_) {
          verify(() =>
                  budgetRepository.addPeriodIncome(PeriodIncome(amount: 2400)))
              .called(1);
          verifyNoMoreInteractions(budgetRepository);
        });

    PeriodIncome expectedPeriodIncome = PeriodIncome(amount: 600);
    blocTest<BudgetManagerBloc, BudgetManagerBlocState>(
        'Add second budget period income',
        build: () => BudgetManagerBloc(budgetRepository),
        seed: () => DetailedBudget(
            period: existingBudgetPeriod, incomes: [exitingPeriodIncome]),
        setUp: () {
          when(() => budgetRepository
                  .addPeriodIncome(any(that: isA<PeriodIncome>())))
              .thenAnswer((_) => Future.value());
        },
        act: (bloc) => bloc.add(AddPeriodIncome(amount: 600)),
        expect: () => [
              DetailedBudget(
                  period: existingBudgetPeriod,
                  incomes: [exitingPeriodIncome],
                  isAddingIncome: true),
              DetailedBudget(
                  period: existingBudgetPeriod,
                  incomes: [exitingPeriodIncome, expectedPeriodIncome],
                  isAddingIncome: false)
            ],
        verify: (_) {
          verify(() =>
                  budgetRepository.addPeriodIncome(PeriodIncome(amount: 600)))
              .called(1);
          verifyNoMoreInteractions(budgetRepository);
        });
  });
}
