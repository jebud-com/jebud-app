import 'package:core/src/blocs/budget_bloc.dart';
import 'package:core/src/entities/budget_details.dart';
import 'package:core/src/entities/period_expense.dart';
import 'package:core/src/entities/period_income.dart';
import 'package:core/src/projections.dart';
import 'package:test/test.dart';

void main() {
  test('Calculate estimate for month before start budgeting', () {
    final detailedBudget = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: 500, startingMonth: DateTime.parse("2023-03-01")));
    expect(detailedBudget.estimateSavingsUpTo(DateTime.parse("2023-02-01")),
        equals(0));
  });

  test('Calculate estimation for any month without income', () {
    final detailedBudget = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: 500, startingMonth: DateTime.parse("2023-03-01")));
    expect(detailedBudget.estimateSavingsUpTo(DateTime.now()), equals(500));
  });

  test('Cacluate estimation with one income', () {
    var startingMonth = DateTime.parse("2023-03-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: startingMonth,
        incomes: [PeriodIncome(amount: 399)],
        expected: 500 + 399);
  });

  test('Cacluate estimation with one income after 3 months', () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: threeMonthsLater,
        incomes: [PeriodIncome(amount: 399)],
        expected: 500 + 399 + 399 + 399);
  });

  test('Cacluate estimation with one income after 16 months', () {
    var startingMonth = DateTime.parse("2023-03-01");
    var sixteenMonthsLater = DateTime.parse("2024-06-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: sixteenMonthsLater,
        incomes: [PeriodIncome(amount: 399)],
        expected: 500 + 399 * 16);
  });

  test('Calculte estimation with many incomes after 3 months', () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: threeMonthsLater,
        incomes: [PeriodIncome(amount: 399), PeriodIncome(amount: 200)],
        expected: 500 + 399 * 3 + 200 * 3);
  });

  test(
      'Calculate estimation with single income for 1 month and single monthly interminable expense',
      () {
    var startingMonth = DateTime.parse("2023-03-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 400,
        startingMonth: startingMonth,
        targetMonth: startingMonth,
        incomes: [PeriodIncome(amount: 399)],
        expenses: [PeriodExpense(amount: 200, startingFrom: startingMonth)],
        expected: 400 + 399 - 200);
  });

  test(
      'Calculate estimation with single income for 3 month and single monthly interminable expense',
      () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 400,
        startingMonth: startingMonth,
        targetMonth: threeMonthsLater,
        incomes: [PeriodIncome(amount: 399)],
        expenses: [PeriodExpense(amount: 200, startingFrom: startingMonth)],
        expected: 400 + 399 + 399 + 399 - 200 - 200 - 200);
  });

  test(
      'Calculate estimation with single income for 3 month and single monthly interminable expense but starts 2nd month',
      () {
    var startingMonth = DateTime.parse("2023-03-01");
    var oneMonthLater = DateTime.parse("2023-04-01");
    var threeMonthsLater = DateTime.parse("2023-05-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 400,
        startingMonth: startingMonth,
        targetMonth: threeMonthsLater,
        incomes: [
          PeriodIncome(amount: 399),
        ],
        expenses: [
          PeriodExpense(amount: 200, startingFrom: startingMonth),
          PeriodExpense(amount: 60, startingFrom: oneMonthLater)
        ],
        expected: 400 + 399 + 399 + 399 - 200 - 200 - 200 - 60 - 60);
  });

  test(
      'Calculate estimation with single income for 3 month and single monthly interminable expense and one terminable after a month',
      () {
    var startingMonth = DateTime.parse("2023-03-01");
    var twoMonthsLater = DateTime.parse("2023-04-01");
    var threeMonthsLater = DateTime.parse("2023-05-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 400,
        startingMonth: startingMonth,
        targetMonth: threeMonthsLater,
        incomes: [PeriodIncome(amount: 399)],
        expenses: [
          PeriodExpense(amount: 200, startingFrom: startingMonth),
          PeriodExpense(
              amount: 50,
              startingFrom: startingMonth,
              applyUntil: twoMonthsLater)
        ],
        expected: 400 + 399 + 399 + 399 - 200 - 200 - 200 - 50 - 50);
  });

  group("Calculate whatIf expense of 300 for different projections", () {
    late DetailedBudget detailedBudget;

    setUp(() {
      detailedBudget = DetailedBudget(
          budgetDetails: BudgetDetails(
              startingAmount: 500, startingMonth: DateTime.parse("2023-03-01")),
          incomes: [
            PeriodIncome(amount: 300)
          ],
          expenses: [
            PeriodExpense(
                amount: 40, startingFrom: DateTime.parse("2023-03-01")),
            PeriodExpense(
                amount: 10,
                startingFrom: DateTime.parse("2023-05-01"),
                applyUntil: DateTime.parse("2023-07-01"))
          ]);
    });

    test('Calculated a WhatIf expense for current Month', () {
      var result = detailedBudget.estimateWhatIfISpend(
          amount: 200,
          startingFrom: DateTime.parse("2023-03-01"),
          until: DateTime.parse("2023-07-01"),
          projectFor: Projections.oneMonth);

      expect(result, equals(560));
    });

    test('Calculated a WhatIf expense for next three months', () {
      var result = detailedBudget.estimateWhatIfISpend(
          amount: 200,
          startingFrom: DateTime.parse("2023-03-01"),
          until: DateTime.parse("2023-07-01"),
          projectFor: Projections.threeMonths);

      expect(result, equals(670));
    });

    test('Calculated a WhatIf expense for next six months', () {
      var result = detailedBudget.estimateWhatIfISpend(
          amount: 200,
          startingFrom: DateTime.parse("2023-03-01"),
          until: DateTime.parse("2023-07-01"),
          projectFor: Projections.sixMonths);

      expect(result, equals(1030));
    });

    test('Calculated a WhatIf expense for one year months', () {
      var result = detailedBudget.estimateWhatIfISpend(
          amount: 200,
          startingFrom: DateTime.parse("2023-03-01"),
          until: DateTime.parse("2023-07-01"),
          projectFor: Projections.oneYear);

      expect(result, equals(2590));
    });

    test('Calculated a WhatIf expense for next three six but the expense starts two months later', () {
      var result = detailedBudget.estimateWhatIfISpend(
          amount: 200,
          startingFrom: DateTime.parse("2023-05-01"),
          until: DateTime.parse("2023-07-01"),
          projectFor: Projections.sixMonths);

      expect(result, equals(1430));
    });
    
  });
}

void calculateEstimationForMonthsAndForIncomes(
    {required double startingAmount,
    required DateTime startingMonth,
    required DateTime targetMonth,
    required List<PeriodIncome> incomes,
    required double expected,
    List<PeriodExpense>? expenses}) {
  final detailedBudget = DetailedBudget(
      budgetDetails: BudgetDetails(
          startingAmount: startingAmount, startingMonth: startingMonth),
      incomes: incomes,
      expenses: expenses);

  var result = detailedBudget.estimateSavingsUpTo(targetMonth);

  expect(result, expected);
}
