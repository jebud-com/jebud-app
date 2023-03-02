import 'package:core/src/entities/period_income.dart';

import '../entities/budget_details.dart';

abstract class BudgetRepository {
  Future addPeriodIncome(PeriodIncome income);
  Future saveBudgetDetails(BudgetDetails budgetDetails);
}
