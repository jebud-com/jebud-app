import 'package:core/src/entities/daily_expense.dart';
import 'package:core/src/entities/period_expense.dart';
import 'package:core/src/entities/period_income.dart';
import 'package:dartz/dartz.dart';

import '../entities/budget_details.dart';
import '../entities/daily_expense_period_allocation.dart';
import '../failures/failure.dart';

abstract class BudgetRepository {
  Future addPeriodIncome(PeriodIncome income);

  Future saveBudgetDetails(BudgetDetails budgetDetails);

  Future addPeriodExpense(PeriodExpense periodExpense);

  Future addDailyExpenseAllocation(
      DailyExpensePeriodAllocation dailyExpensePeriodAllocation);

  Future addDailyExpense(DailyExpense dailExpense);

  Future<Either<Failure, BudgetDetails>> getBudgetDetails();

  Future<Iterable<PeriodIncome>> getPeriodIncomes();

  Future<Iterable<PeriodExpense>> getPeriodExpenses();

  Future<DailyExpensePeriodAllocation?> getDailyExpenseAllocation();

  Future<Iterable<DailyExpense>> getDailyExpenses();
}
