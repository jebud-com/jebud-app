import 'package:core/src/entities/period_expense.dart';
import 'package:core/src/entities/period_income.dart';

import '../entities/budget_details.dart';
import '../entities/daily_expense_period_allocation.dart';

abstract class BudgetRepository {
  Future addPeriodIncome(PeriodIncome income);

  Future saveBudgetDetails(BudgetDetails budgetDetails);

  Future addPeriodExpense(PeriodExpense periodExpense);

  Future addDailyExpenseAllocation(
      DailyExpensePeriodAllocation dailyExpensePeriodAllocation);
}
