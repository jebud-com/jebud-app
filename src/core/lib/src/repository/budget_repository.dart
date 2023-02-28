import 'package:core/src/entities/budget_period.dart';

abstract class BudgetRepository {
  Future saveBudgetPeriod(BudgetPeriod period);
}
