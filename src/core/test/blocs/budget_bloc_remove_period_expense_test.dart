import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/src/blocs/budget_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'fakes/mock_budget_repository.dart';
import 'fakes/mock_datetime_service.dart';

void main() {
  late MockBudgetRepository budgetRepository;
  late MockDateTimeService dateTimeService;
  final periodExpenseToKeep = PeriodExpense(
      amount: 17.99,
      startingFrom: DateTime.parse("2022-10-10"),
      description: "Netflix");

  DetailedBudget initialStateWith(
      {required List<PeriodExpense> periodExpenses,
      required bool isDeletingPeriodExpense,
      required bool isStoppingPeriodExpense}) {
    final DetailedBudget initialState = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: 500, startingMonth: DateTime.parse("2022-01-01")),
        expenses: periodExpenses,
        isPermanentlyDeletingPeriodExpense: isDeletingPeriodExpense,
        isStoppingPeriodExpense: isStoppingPeriodExpense);
    return initialState;
  }

  setUp(() {
    registerFallbackValue(PeriodExpense(
        amount: 23, startingFrom: DateTime.now(), description: ""));
    budgetRepository = MockBudgetRepository();
    when(() => budgetRepository
            .permanentlyDeletePeriodExpense(any(that: isA<PeriodExpense>())))
        .thenAnswer((invocation) async => Future.value());
    when(() => budgetRepository
            .updatePeriodExpense(any(that: isA<PeriodExpense>())))
        .thenAnswer((invocation) async => Future.value());
    dateTimeService = MockDateTimeService();
  });

  final periodExpenseToDelete = PeriodExpense(
      amount: 13,
      startingFrom: DateTime.parse("2022-10-12"),
      description: "Prime");
  blocTest<BudgetManagerBloc, BudgetManagerBlocState>(
      "Given budget with period expenses, when deleting a specific period expense, then it should be deleted",
      seed: () => initialStateWith(
          periodExpenses: [periodExpenseToKeep, periodExpenseToDelete],
          isDeletingPeriodExpense: false,
          isStoppingPeriodExpense: false),
      build: () => BudgetManagerBloc(budgetRepository, dateTimeService),
      act: (bloc) =>
          bloc.add(PermanentlyDeletePeriodExpense(periodExpenseToDelete)),
      expect: () => [
            initialStateWith(
                periodExpenses: [periodExpenseToKeep, periodExpenseToDelete],
                isDeletingPeriodExpense: true,
                isStoppingPeriodExpense: false),
            initialStateWith(
                periodExpenses: [periodExpenseToKeep],
                isDeletingPeriodExpense: false,
                isStoppingPeriodExpense: false)
          ],
      verify: (_) {
        verify(() => budgetRepository
            .permanentlyDeletePeriodExpense(periodExpenseToDelete));
        verifyNoMoreInteractions(budgetRepository);
      });

  final periodExpenseToStop = PeriodExpense(
      amount: 50,
      startingFrom: DateTime.parse("2023-01-01"),
      description: "Car Insurance");
  final stoppingDate = DateTime.parse("2023-05-01");
  final stoppedPeriodExpense = PeriodExpense(
      amount: 50,
      startingFrom: DateTime.parse("2023-01-01"),
      description: "Car Insurance",
      applyUntil: stoppingDate);

  blocTest<BudgetManagerBloc, BudgetManagerBlocState>(
      "Given budget with period expense, when stopping a period expense at a date, then it should be applied until that date",
      seed: () => initialStateWith(
            periodExpenses: [periodExpenseToKeep, periodExpenseToStop],
            isDeletingPeriodExpense: false,
            isStoppingPeriodExpense: false,
          ),
      build: () => BudgetManagerBloc(budgetRepository, dateTimeService),
      act: (bloc) =>
          bloc.add(StopPeriodExpense(periodExpenseToStop, at: stoppingDate)),
      expect: () => [
            initialStateWith(
                periodExpenses: [periodExpenseToKeep, periodExpenseToStop],
                isDeletingPeriodExpense: false,
                isStoppingPeriodExpense: true),
            initialStateWith(
                periodExpenses: [periodExpenseToKeep, stoppedPeriodExpense],
                isDeletingPeriodExpense: false,
                isStoppingPeriodExpense: false)
          ],
      verify: (_) {
        verify(
            () => budgetRepository.updatePeriodExpense(stoppedPeriodExpense));
        verifyNoMoreInteractions(budgetRepository);
      });
}
