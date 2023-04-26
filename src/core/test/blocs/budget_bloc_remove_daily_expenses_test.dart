@Timeout(Duration(seconds: 10))
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/src/blocs/budget_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'fakes/mock_budget_repository.dart';
import 'fakes/mock_datetime_service.dart';

void main() {
  final budgetRepository = MockBudgetRepository();
  final dateTimeService = MockDateTimeService();
  late BudgetManagerBloc budgetBloc;
  late final dailyExpenseToKeep = DailyExpense(
      amount: 30,
      day: DateTime.now().add(Duration(days: 1)),
      description: "Monoprix");
  late final dailyExpenseToDelete =
      DailyExpense(amount: 30, day: DateTime.now(), description: "Monoprix");

  DetailedBudget getDetailedBudgetWithDailyExpense(
      {required List<DailyExpense> dailyExpenses,
      required bool isDeletingDailyExpense}) {
    final detailedBudget = DetailedBudget(
        budgetDetails: BudgetDetails(
          startingAmount: 600,
          startingMonth: DateTime.parse("2021-11-25"),
        ),
        dailyExpenses: dailyExpenses,
        isDeletingDailyExpense: isDeletingDailyExpense);
    return detailedBudget;
  }

  setUp(() {
    registerFallbackValue(
        DailyExpense(amount: 0, description: "", day: DateTime.now()));
    when(() =>
            budgetRepository.deleteDailyExpense(any(that: isA<DailyExpense>())))
        .thenAnswer((_) => Future.value());
    budgetBloc = BudgetManagerBloc(budgetRepository, dateTimeService);
  });

  blocTest<BudgetManagerBloc, BudgetManagerBlocState>(
      "Given Detailed Budget with a single daily expense "
      "When deleting that daily expense"
      "Then the detailed budget should be empty, and daily expense should be deleted from database",
      build: () => budgetBloc,
      seed: () => getDetailedBudgetWithDailyExpense(
          dailyExpenses: [dailyExpenseToDelete], isDeletingDailyExpense: false),
      act: (bloc) => bloc.add(DeleteDailyExpense(dailyExpenseToDelete)),
      expect: () => [
            getDetailedBudgetWithDailyExpense(
                dailyExpenses: [dailyExpenseToDelete],
                isDeletingDailyExpense: true),
            getDetailedBudgetWithDailyExpense(
                dailyExpenses: [], isDeletingDailyExpense: false)
          ],
      verify: (_) {
        verify(() => budgetRepository.deleteDailyExpense(dailyExpenseToDelete))
            .called(1);
        verifyNoMoreInteractions(budgetRepository);
      });

  blocTest<BudgetManagerBloc, BudgetManagerBlocState>(
      "Given Detailed Budget with a two daily expense "
      "When deleting one daily expense"
      "Then the detailed budget should one daily expense, and the deleted daily expense should be deleted from database",
      build: () => budgetBloc,
      seed: () => getDetailedBudgetWithDailyExpense(
          dailyExpenses: [dailyExpenseToDelete, dailyExpenseToKeep], isDeletingDailyExpense: false),
      act: (bloc) => bloc.add(DeleteDailyExpense(dailyExpenseToDelete)),
      expect: () => [
            getDetailedBudgetWithDailyExpense(
                dailyExpenses: [dailyExpenseToDelete, dailyExpenseToKeep],
                isDeletingDailyExpense: true),
            getDetailedBudgetWithDailyExpense(
                dailyExpenses: [dailyExpenseToKeep], isDeletingDailyExpense: false)
          ],
      verify: (_) {
        verify(() => budgetRepository.deleteDailyExpense(dailyExpenseToDelete))
            .called(1);
        verifyNoMoreInteractions(budgetRepository);
      });
}
