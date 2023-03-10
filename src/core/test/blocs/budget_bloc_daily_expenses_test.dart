import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/src/blocs/budget_bloc.dart';
import 'package:core/src/entities/budget_details.dart';
import 'package:core/src/entities/daily_expense_period_allocation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'fakes/mock_budget_repository.dart';
import 'fakes/mock_datetime_service.dart';

void main() {
  final MockBudgetRepository budgetRepository = MockBudgetRepository();
  final MockDateTimeService dateTimeService = MockDateTimeService();
  final BudgetManagerBloc budgetManagerBloc =
      BudgetManagerBloc(budgetRepository, dateTimeService);
  final DateTime budgetStartDate = DateTime.parse("2023-02-01");

  setUp(() {
    registerFallbackValue(DailyExpensePeriodAllocation(amount: 0));
  });
  
  blocTest<BudgetManagerBloc, BudgetManagerBlocState>(
      "Adding Daily Expense Allocation",
      build: () => budgetManagerBloc,
      setUp: () {
        when(() => budgetRepository.addDailyExpenseAllocation(
                any(that: isA<DailyExpensePeriodAllocation>())))
            .thenAnswer((invocation) => Future.value());
      },
      seed: () => DetailedBudget(
          budgetDetails: BudgetDetails(
              startingAmount: 100, startingMonth: budgetStartDate)),
      act: (bloc) => bloc.add(AddDailyExpenseAllocation(amount: 400)),
      expect: () => [
            DetailedBudget(
                budgetDetails: BudgetDetails(
                    startingAmount: 100, startingMonth: budgetStartDate),
                isAddingDailyExpenseAllocation: true),
            DetailedBudget(
                budgetDetails: BudgetDetails(
                    startingAmount: 100, startingMonth: budgetStartDate),
                isAddingDailyExpenseAllocation: false,
                dailyExpenseAllocation:
                    DailyExpensePeriodAllocation(amount: 400)),
          ],
      verify: (_) {
        verify(() => budgetRepository.addDailyExpenseAllocation(
            DailyExpensePeriodAllocation(amount: 400))).called(1);
        verifyNoMoreInteractions(budgetRepository);
      });
}
