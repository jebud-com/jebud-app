import 'package:core/src/blocs/budget_bloc.dart';
import 'package:core/src/entities/budget_details.dart';
import 'package:core/src/entities/period_income.dart';
import 'package:test/test.dart';

void main() {
  test('Calculate estimation for any month without income', () {
    final detailedBudget = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: 500, startingMonth: DateTime.parse("2023-03-01")));
    expect(detailedBudget.estimateSavingsUpTo(DateTime.now()), equals(500));
  });

  test('Cacluate estimation with one income', () {
    var startingMonth = DateTime.parse("2023-03-01");
    final detailedBudget = DetailedBudget(
        budgetDetails:
            BudgetDetails(startingAmount: 500, startingMonth: startingMonth),
        incomes: [PeriodIncome(amount: 399)]);

    var result = detailedBudget.estimateSavingsUpTo(startingMonth);

    expect(result, 500 + 399);
  });

  test('Cacluate estimation with one income after 3 months', () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-01");
    final detailedBudget = DetailedBudget(
        budgetDetails:
            BudgetDetails(startingAmount: 500, startingMonth: startingMonth),
        incomes: [PeriodIncome(amount: 399)]);

    var result = detailedBudget.estimateSavingsUpTo(threeMonthsLater);

    expect(result, 500 + 399 + 399 + 399);
  });

  test('Cacluate estimation with one income after 16 months', () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2024-06-01");
    final detailedBudget = DetailedBudget(
        budgetDetails:
            BudgetDetails(startingAmount: 500, startingMonth: startingMonth),
        incomes: [PeriodIncome(amount: 399)]);

    var result = detailedBudget.estimateSavingsUpTo(threeMonthsLater);

    expect(result, 500 + 399 * 16);
  });
}
