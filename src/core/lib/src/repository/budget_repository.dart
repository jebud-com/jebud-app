import 'package:core/src/entities/budget_period.dart';
import 'package:core/src/entities/period_income.dart';

abstract class BudgetRepository {
  Future saveBudgetPeriod(BudgetPeriod period);
  Future addPeriodIncome(PeriodIncome income);
}
