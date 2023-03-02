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
    calculateEstimationForMonthsAndForIncomes(500, startingMonth, startingMonth,
        [PeriodIncome(amount: 399)], 500 + 399);
  });

  test('Cacluate estimation with one income after 3 months', () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-01");
    calculateEstimationForMonthsAndForIncomes(500, startingMonth,
        threeMonthsLater, [PeriodIncome(amount: 399)], 500 + 399 + 399 + 399);
  });

  test('Cacluate estimation with one income after 16 months', () {
    var startingMonth = DateTime.parse("2023-03-01");
    var sixteenMonthsLater = DateTime.parse("2024-06-01");
    calculateEstimationForMonthsAndForIncomes(500, startingMonth,
        sixteenMonthsLater, [PeriodIncome(amount: 399)], 500 + 399 * 16);
  });

  test('Calculte estimation wich many incomes after 3 months', () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-01");
    calculateEstimationForMonthsAndForIncomes(
        500,
        startingMonth,
        threeMonthsLater,
        [PeriodIncome(amount: 399), PeriodIncome(amount: 200)],
        500 + 399 * 3 + 200 * 3);
  });
}

void calculateEstimationForMonthsAndForIncomes(
    double startingAmount,
    DateTime startingMonth,
    DateTime targetMonth,
    List<PeriodIncome> incomes,
    double expected) {
  final detailedBudget = DetailedBudget(
      budgetDetails: BudgetDetails(
          startingAmount: startingAmount, startingMonth: startingMonth),
      incomes: incomes);

  var result = detailedBudget.estimateSavingsUpTo(targetMonth);

  expect(result, expected);
}
