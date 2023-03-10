import 'package:core/core.dart';
import 'package:core/src/entities/daily_expense_period_allocation.dart';
import 'package:test/test.dart';

import 'extensions/detailed_budget_ext.dart';

void main() {
  group('monthly, weekly and daily amount of daily expenses', () {
    var budgetDetails = DetailedBudget(
        budgetDetails: BudgetDetails(
            startingAmount: 500, startingMonth: DateTime.parse("2023-01-01")),
        incomes: [PeriodIncome(amount: 2500, description: 'salary')],
        dailyExpenseAllocation: DailyExpensePeriodAllocation(amount: 400),
        expenses: [
          PeriodExpense(
              amount: 300,
              startingFrom: DateTime.parse("2023-01-01"),
              description: "Health insurance")
        ]);

    group("No daily expenses", () {
      test("daily Expense - start of month and no daily expense", () {
        var dailyLeft = budgetDetails
            .getLeftDailyExpenseForRunningDay(DateTime.parse("2023-01-01"));
        expect(dailyLeft, equals(12.90));
      });

      test("week Expense - start of month and no daily expense", () {
        var dailyLeft = budgetDetails
            .getLeftDailyExpenseForRunningWeek(DateTime.parse("2023-01-01"));
        expect(dailyLeft, equals(12.90));
      });

      test("month Expense - start of month and no daily expense", () {
        var dailyLeft = budgetDetails
            .getLeftDailyExpenseForRunningMonth(DateTime.parse("2023-01-01"));
        expect(dailyLeft, equals(400));
      });

      test("daily Expense - start of week and no daily expense", () {
        var dailyLeft = budgetDetails
            .getLeftDailyExpenseForRunningDay(DateTime.parse("2023-01-02"));
        expect(dailyLeft, equals(13.33));
      });

      test("daily Expense - end of month and no daily expense", () {
        var dailyLeft = budgetDetails
            .getLeftDailyExpenseForRunningDay(DateTime.parse("2023-01-31"));
        expect(dailyLeft, equals(400));
      });

      test("daily Expense - two days before end of month and no daily expense",
          () {
        var dailyLeft = budgetDetails
            .getLeftDailyExpenseForRunningDay(DateTime.parse("2023-01-30"));
        expect(dailyLeft, equals(200));
      });

      test("week Expense - start of start of week  and no daily expense", () {
        var dailyLeft = budgetDetails
            .getLeftDailyExpenseForRunningWeek(DateTime.parse("2023-01-02"));
        expect(dailyLeft, equals(93.31));
      });

      test("week Expense - end of last of week  and no daily expense", () {
        var dailyLeft = budgetDetails
            .getLeftDailyExpenseForRunningWeek(DateTime.parse("2023-01-30"));
        expect(dailyLeft, equals(400));
      });

      test("month Expense - later in month no daily expense", () {
        var dailyLeft = budgetDetails
            .getLeftDailyExpenseForRunningMonth(DateTime.parse("2023-01-06"));
        expect(dailyLeft, equals(400));
      });
    });

    group("with daily expenses", () {
      var dailySpentBudgetDetails = budgetDetails.addDailyExpense(
          amount: 10, day: DateTime.parse("2023-01-01"), description: "Burger");

      test("daily Expense - start of month and partial daily expense", () {
        var dailyLeft = dailySpentBudgetDetails
            .getLeftDailyExpenseForRunningDay(DateTime.parse("2023-01-01"));
        expect(dailyLeft, equals(2.90));
      });

      test("weekly Expense - start of month and partial daily expense", () {
        var weeklyLeft = dailySpentBudgetDetails
            .getLeftDailyExpenseForRunningWeek(DateTime.parse("2023-01-01"));
        expect(weeklyLeft, equals(2.90));
      });

      test("monthly expense - start of month and partial daily expense", () {
        var monthlyLeft = dailySpentBudgetDetails
            .getLeftDailyExpenseForRunningMonth(DateTime.parse("2023-01-01"));
        expect(monthlyLeft, equals(400 - 10));
      });

      test("daily Expense - next week of month and partial daily expense", () {
        var dailyLeft = dailySpentBudgetDetails
            .getLeftDailyExpenseForRunningDay(DateTime.parse("2023-01-02"));
        expect(dailyLeft, equals(13));
      });
      test("daily Expense - next week of month and two partial daily expense",
          () {
        var dailyLeft = dailySpentBudgetDetails
            .addDailyExpense(
                amount: 12,
                day: DateTime.parse("2023-01-02"),
                description: "junk")
            .getLeftDailyExpenseForRunningDay(DateTime.parse("2023-01-02"));
        expect(dailyLeft, equals(1));
      });

      test("weekly Expense - next week of month and partial daily expense", () {
        var dailyLeft = dailySpentBudgetDetails
            .getLeftDailyExpenseForRunningWeek(DateTime.parse("2023-01-02"));
        expect(dailyLeft, equals(91));
      });
    });

    group("with excessive daily expenses", () {
      var dailyExcessiveSpentBudgetDetails = budgetDetails.addDailyExpense(
          amount: 20, day: DateTime.parse("2023-01-01"), description: "Burger");

      test("daily Expense - start of month and excessive daily expense", () {
        var dailyLeft = dailyExcessiveSpentBudgetDetails
            .getLeftDailyExpenseForRunningDay(DateTime.parse("2023-01-01"));
        expect(dailyLeft, equals(-7.1));
      });

      test("daily Expense - next day  of month and excessive daily expense",
          () {
        var dailyLeft = dailyExcessiveSpentBudgetDetails
            .getLeftDailyExpenseForRunningDay(DateTime.parse("2023-01-02"));
        expect(dailyLeft, equals(12.67));
      });

      test("daily Expense - next day of month and two excessive daily expense",
          () {
        var dailyLeft = dailyExcessiveSpentBudgetDetails
            .addDailyExpense(
                amount: 12.67,
                day: DateTime.parse("2023-01-02"),
                description: '')
            .getLeftDailyExpenseForRunningDay(DateTime.parse("2023-01-02"));
        expect(dailyLeft, equals(0));
      });

      test("daily Expense - third day of month and two excessive daily expense",
          () {
        var dailyLeft = dailyExcessiveSpentBudgetDetails
            .addDailyExpense(
                amount: 15,
                day: DateTime.parse("2023-01-02"),
                description: 'just stuff')
            .getLeftDailyExpenseForRunningDay(DateTime.parse("2023-01-03"));
        expect(dailyLeft, equals(12.59));
      });
    });
  });
}
