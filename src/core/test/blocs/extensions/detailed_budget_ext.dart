import 'package:core/src/blocs/budget_bloc.dart';
import 'package:core/src/entities/daily_expense.dart';

extension DetailedBudgetExt on DetailedBudget {
  DetailedBudget addDailyExpense(
      {required double amount,
        required DateTime day,
        required String description}) {
    return DetailedBudget.copyFromWith(this, dailyExpenses: [
      ...dailyExpenses,
      DailyExpense(description: description, amount: amount, day: day)
    ]);
  }
}
