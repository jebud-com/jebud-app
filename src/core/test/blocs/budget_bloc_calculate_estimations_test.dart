import 'package:core/src/blocs/budget_bloc.dart';
import 'package:core/src/entities/budget_details.dart';
import 'package:core/src/utils/date_time_extensions.dart';
import 'extensions/detailed_budget_ext.dart';
import 'package:core/src/entities/daily_expense_period_allocation.dart';
import 'package:core/src/entities/period_expense.dart';
import 'package:core/src/entities/period_income.dart';
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

  test('Calculate estimation with one income', () {
    var startingMonth = DateTime.parse("2023-03-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: startingMonth,
        incomes: [
          PeriodIncome(
              amount: 399,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        expected: 500 + 399);
  });

  test('Calculate estimation with one income after 3 months', () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: threeMonthsLater,
        incomes: [
          PeriodIncome(
              amount: 399,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        expected: 500 + 399 + 399 + 399);
  });

  test('Calculate estimation with one income after 16 months', () {
    var startingMonth = DateTime.parse("2023-03-01");
    var sixteenMonthsLater = DateTime.parse("2024-06-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: sixteenMonthsLater,
        incomes: [
          PeriodIncome(
              amount: 399,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        expected: 500 + 399 * 16);
  });

  test('Calculate estimation with many incomes after 3 months', () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: threeMonthsLater,
        incomes: [
          PeriodIncome(
              amount: 399,
              description: '',
              startingFrom: DateTime.parse("2023-03-01")),
          PeriodIncome(
              amount: 200,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        expected: 500 + 399 * 3 + 200 * 3);
  });

  test(
      "Calculate estimation with many incomes and expenses same day should ignore time",
      () {
    var startingMonth = DateTime.now()
        .copyWith(year: 2023, month: 03, day: 01, hour: 00, minute: 20);
    var nextMonth = DateTime.now()
        .copyWith(year: 2023, month: 04, day: 01)
        .getSameDayMidnight();
    var oneDayAfterAtMidnight = DateTime.now()
        .copyWith(year: 2023, month: 03, day: 01, hour: 00, minute: 10);
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: -500,
        startingMonth: startingMonth,
        targetMonth: oneDayAfterAtMidnight,
        incomes: [
          PeriodIncome(amount: 399, description: '', startingFrom: nextMonth),
          PeriodIncome(amount: 200, description: '', startingFrom: nextMonth)
        ],
        expenses: [
          PeriodExpense(
              amount: 650, startingFrom: nextMonth, description: "rent")
        ],
        expected: -500);
  });

  test("When Period Income is in the future and estimating before it beings",
      () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: startingMonth,
        incomes: [
          PeriodIncome(
              amount: 399, description: '', startingFrom: threeMonthsLater),
        ],
        expected: 500);
  });

  test(
      "When Period Income is in the future and estimating during same month it begins",
      () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-05");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: DateTime.parse("2023-05-01"),
        incomes: [
          PeriodIncome(
              amount: 399, description: '', startingFrom: threeMonthsLater),
        ],
        expected: 500 + 399);
  });

  test(
      "When Period Income is in the future and estimating during same month it begins",
      () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-05");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: DateTime.parse("2023-05-15"),
        incomes: [
          PeriodIncome(
              amount: 399, description: '', startingFrom: threeMonthsLater),
        ],
        expected: 500 + 399);
  });

  test(
      "When Period Income is in the future and estimating during three months it begins",
      () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-05");
    var sixMonthsLater = DateTime.parse("2023-07-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: sixMonthsLater,
        incomes: [
          PeriodIncome(
              amount: 399, description: '', startingFrom: threeMonthsLater),
        ],
        expected: 500 + 399 * 3);
  });

  test(
      "When 3 months Period Income is in the future and estimating during one months after it ends",
      () {
    var startingMonth = DateTime.parse("2023-03-01");
    var threeMonthsLater = DateTime.parse("2023-05-05");
    var sixMonthsLater = DateTime.parse("2023-07-01");
    var sevenMonthsLater = DateTime.parse("2023-08-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 500,
        startingMonth: startingMonth,
        targetMonth: sevenMonthsLater,
        incomes: [
          PeriodIncome(
              amount: 399,
              description: '',
              startingFrom: threeMonthsLater,
              applyUntil: sixMonthsLater),
        ],
        expected: 500 + 399 * 3);
  });

  test(
      'Calculate estimation with single income for 1 month and single monthly interminable expense',
      () {
    var startingMonth = DateTime.parse("2023-03-01");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 400,
        startingMonth: startingMonth,
        targetMonth: startingMonth,
        incomes: [
          PeriodIncome(
              amount: 399,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        expenses: [
          PeriodExpense(
              amount: 200, description: 'netflix', startingFrom: startingMonth)
        ],
        expected: 400 + 399 - 200);
  });

  test(
      'Calculate estimation with single income for 1 month and single monthly interminable expense starting half of the month',
      () {
    var startingMonth = DateTime.parse("2023-03-01");
    var halfOfStartingMonth = DateTime.parse("2023-03-15");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 400,
        startingMonth: startingMonth,
        targetMonth: startingMonth,
        incomes: [
          PeriodIncome(
              amount: 399,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        expenses: [
          PeriodExpense(
              amount: 200,
              description: 'netflix',
              startingFrom: halfOfStartingMonth)
        ],
        expected: 400 + 399 - 200);
  });

  test(
      'Calculate estimation with single income for 1 month and single monthly interminable expense starting half of the month should ignore Time component',
      () {
    var startingMonth = DateTime.parse("2023-03-01");
    var halfOfStartingMonth = DateTime.parse("2023-03-15T20:13:00");
    calculateEstimationForMonthsAndForIncomes(
        startingAmount: 400,
        startingMonth: startingMonth,
        targetMonth: startingMonth,
        incomes: [
          PeriodIncome(
              amount: 399,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        expenses: [
          PeriodExpense(
              amount: 200,
              description: 'netflix',
              startingFrom: halfOfStartingMonth)
        ],
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
        incomes: [
          PeriodIncome(
              amount: 399,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        expenses: [
          PeriodExpense(
              amount: 200, startingFrom: startingMonth, description: '')
        ],
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
          PeriodIncome(
              amount: 399,
              description: '',
              startingFrom: DateTime.parse("2023-03-01")),
        ],
        expenses: [
          PeriodExpense(
              amount: 200, startingFrom: startingMonth, description: ''),
          PeriodExpense(
              amount: 60, startingFrom: oneMonthLater, description: '')
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
        incomes: [
          PeriodIncome(
              amount: 399,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        expenses: [
          PeriodExpense(
              amount: 200, startingFrom: startingMonth, description: ''),
          PeriodExpense(
              amount: 50,
              startingFrom: startingMonth,
              applyUntil: twoMonthsLater,
              description: '')
        ],
        expected: 400 + 399 + 399 + 399 - 200 - 200 - 200 - 50 - 50);
  });

  test("Calculate estimation with a daily expense allocation", () {
    final detailedBudget = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: -500, startingMonth: DateTime.parse("2023-03-01")),
        incomes: [
          PeriodIncome(
              amount: 1000,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        dailyExpenseAllocation: DailyExpensePeriodAllocation(amount: 250),
        expenses: [
          PeriodExpense(
              amount: 100,
              startingFrom: DateTime.parse("2023-03-01"),
              description: ''),
        ]);
    var result =
        detailedBudget.estimateSavingsUpTo(DateTime.parse("2023-03-01"));

    expect(result, 150);
  });

  test(
      "Calculate estimation for current month with a daily expense allocation when monthly expense is under control",
      () {
    var detailedBudget = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: -500, startingMonth: DateTime.parse("2023-03-01")),
        incomes: [
          PeriodIncome(
              amount: 1000,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        dailyExpenseAllocation: DailyExpensePeriodAllocation(amount: 250),
        expenses: [
          PeriodExpense(
              amount: 100,
              startingFrom: DateTime.parse("2023-03-01"),
              description: ''),
        ]);

    detailedBudget = detailedBudget.addDailyExpense(
        description: "stuff", amount: 100, day: DateTime.parse("2023-03-10"));

    var result =
        detailedBudget.estimateSavingsUpTo(DateTime.parse("2023-03-01"));

    expect(result, 150);
  });

  test(
      "Calculate estimation for current month next year with a daily expense allocation when monthly expense is under control",
      () {
    var detailedBudget = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: -500, startingMonth: DateTime.parse("2023-03-01")),
        incomes: [],
        dailyExpenseAllocation: DailyExpensePeriodAllocation(amount: 250),
        expenses: []);

    detailedBudget = detailedBudget.addDailyExpense(
        description: "stuff", amount: 100, day: DateTime.parse("2023-03-10"));

    var result =
        detailedBudget.estimateSavingsUpTo(DateTime.parse("2024-03-01"));

    expect(result, -850);
  });

  test(
      "Calculate estimation for current month with a daily expense allocation when monthly expense surpasses allocation",
      () {
    var detailedBudget = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: -500, startingMonth: DateTime.parse("2023-03-01")),
        incomes: [
          PeriodIncome(
              amount: 1000,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        dailyExpenseAllocation: DailyExpensePeriodAllocation(amount: 250),
        expenses: [
          PeriodExpense(
              amount: 100,
              startingFrom: DateTime.parse("2023-03-01"),
              description: ''),
        ]);

    detailedBudget = detailedBudget.addDailyExpense(
        description: "useless", amount: 300, day: DateTime.parse("2023-03-10"));

    var result =
        detailedBudget.estimateSavingsUpTo(DateTime.parse("2023-03-01"));

    expect(result, 100);
  });

  test(
      "Calculate estimation for next month with a daily expense allocation when last monthly expenses is equal to allocation",
      () {
    var detailedBudget = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: -500, startingMonth: DateTime.parse("2023-03-01")),
        incomes: [
          PeriodIncome(
              amount: 1000,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        dailyExpenseAllocation: DailyExpensePeriodAllocation(amount: 250),
        expenses: [
          PeriodExpense(
              amount: 100,
              startingFrom: DateTime.parse("2023-03-01"),
              description: ''),
        ]);

    detailedBudget = detailedBudget.addDailyExpense(
        description: "stuff", amount: 250, day: DateTime.parse("2023-03-10"));

    var result =
        detailedBudget.estimateSavingsUpTo(DateTime.parse("2023-04-01"));

    expect(result, 800);
  });

  test(
      "Calculate estimation for next month with a daily expense allocation when last monthly expenses is less than allocation",
      () {
    var detailedBudget = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: -500, startingMonth: DateTime.parse("2023-03-01")),
        incomes: [
          PeriodIncome(
              amount: 1000,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        dailyExpenseAllocation: DailyExpensePeriodAllocation(amount: 250),
        expenses: [
          PeriodExpense(
              amount: 100,
              startingFrom: DateTime.parse("2023-03-01"),
              description: ''),
        ]);

    detailedBudget = detailedBudget.addDailyExpense(
        description: "stuff", amount: 180, day: DateTime.parse("2023-03-10"));

    var result =
        detailedBudget.estimateSavingsUpTo(DateTime.parse("2023-04-01"));

    expect(result, 870);
  });

  test(
      "Calculate estimation for next month with a daily expense allocation when last monthly expenses is more than allocation",
      () {
    var detailedBudget = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: -500, startingMonth: DateTime.parse("2023-03-01")),
        incomes: [
          PeriodIncome(
              amount: 1000,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        dailyExpenseAllocation: DailyExpensePeriodAllocation(amount: 250),
        expenses: [
          PeriodExpense(
              amount: 100,
              startingFrom: DateTime.parse("2023-03-01"),
              description: ''),
        ]);

    detailedBudget = detailedBudget.addDailyExpense(
        description: "stuff", amount: 300, day: DateTime.parse("2023-03-10"));

    var result =
        detailedBudget.estimateSavingsUpTo(DateTime.parse("2023-04-01"));

    expect(result, 750);
  });

  test("Calculate estimation for 3 month later with a daily expense allocation",
      () {
    var detailedBudget = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: -500, startingMonth: DateTime.parse("2023-03-01")),
        incomes: [
          PeriodIncome(
              amount: 1000,
              description: '',
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        dailyExpenseAllocation: DailyExpensePeriodAllocation(amount: 250),
        expenses: [
          PeriodExpense(
              amount: 100,
              startingFrom: DateTime.parse("2023-03-01"),
              description: ''),
        ]);

    detailedBudget = detailedBudget.addDailyExpense(
        description: "Pizza", amount: 300, day: DateTime.parse("2023-03-10"));
    detailedBudget = detailedBudget.addDailyExpense(
        description: "Car", amount: 80, day: DateTime.parse("2023-04-10"));

    var result =
        detailedBudget.estimateSavingsUpTo(DateTime.parse("2023-05-01"));

    expect(result, 1570);
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
