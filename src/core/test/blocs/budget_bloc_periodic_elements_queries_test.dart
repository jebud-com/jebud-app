import 'dart:developer';

import 'package:core/core.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

void main() {
  final DetailedBudget budget = DetailedBudget(
      budgetDetails: BudgetDetails(
          startingMonth: DateTime(2023, 01, 01), startingAmount: 500),
      incomes: [
        PeriodIncome(
            amount: 50,
            description: "Income 1",
            startingFrom: DateTime(2023, 01, 01)),
        PeriodIncome(
            amount: 50,
            description: "Income 1.2",
            startingFrom: DateTime(2023, 01, 01),
            applyUntil: DateTime(2023, 02, 01)),
        PeriodIncome(
            amount: 50,
            description: "Income 2",
            startingFrom: DateTime(2023, 01, 01),
            applyUntil: DateTime(2023, 03, 01)),
        PeriodIncome(
            amount: 50,
            description: "Income 4",
            startingFrom: DateTime(2023, 03, 01),
            applyUntil: DateTime(2023, 03, 01)),
        PeriodIncome(
            amount: 50,
            description: "Income 5",
            startingFrom: DateTime(2023, 03, 01)),
        PeriodIncome(
            amount: 50,
            description: "Income 7",
            startingFrom: DateTime(2023, 03, 01),
            applyUntil: DateTime(2023, 05, 01)),
        PeriodIncome(
            amount: 50,
            description: "Income 8",
            startingFrom: DateTime(2023, 05, 01),
            applyUntil: DateTime(2023, 07, 01)),
        PeriodIncome(
            amount: 50,
            description: "Income 9",
            startingFrom: DateTime(2023, 05, 01)),
      ],
      expenses: [
        PeriodExpense(
            amount: 50,
            description: "Expense 1.2",
            startingFrom: DateTime(2023, 01, 01),
            applyUntil: DateTime(2023, 02, 01)),
        PeriodExpense(
            amount: 50,
            description: "Expense 1",
            startingFrom: DateTime(2023, 01, 01)),
        PeriodExpense(
            amount: 50,
            description: "Expense 2",
            startingFrom: DateTime(2023, 01, 01),
            applyUntil: DateTime(2023, 03, 01)),
        PeriodExpense(
            amount: 50,
            description: "Expense 4",
            startingFrom: DateTime(2023, 03, 01),
            applyUntil: DateTime(2023, 03, 01)),
        PeriodExpense(
            amount: 50,
            description: "Expense 5",
            startingFrom: DateTime(2023, 03, 01)),
        PeriodExpense(
            amount: 50,
            description: "Expense 7",
            startingFrom: DateTime(2023, 03, 01),
            applyUntil: DateTime(2023, 05, 01)),
        PeriodExpense(
            amount: 50,
            description: "Expense 8",
            startingFrom: DateTime(2023, 05, 01),
            applyUntil: DateTime(2023, 07, 01)),
        PeriodExpense(
            amount: 50,
            description: "Expense 9",
            startingFrom: DateTime(2023, 05, 01)),
      ]);

  test(
      "Given detailed budget with income and expenses, when request income for a month with not period income, then return empty",
      () {
    final result = budget.getActivePeriodIncomeFor(DateTime(2022, 12, 20));
    expect(result, isEmpty);
  });

  test(
      "Given detailed budget with income and expense, when request income for a month, get only incomes still on going during that month",
      () {
    final result = budget.getActivePeriodIncomeFor(DateTime(2023, 03, 20));

    expect(
        result,
        unorderedEquals([
          PeriodIncome(
              amount: 50,
              description: "Income 1",
              startingFrom: DateTime(2023, 01, 01)),
          PeriodIncome(
              amount: 50,
              description: "Income 2",
              startingFrom: DateTime(2023, 01, 01),
              applyUntil: DateTime(2023, 03, 01)),
          PeriodIncome(
              amount: 50,
              description: "Income 4",
              startingFrom: DateTime(2023, 03, 01),
              applyUntil: DateTime(2023, 03, 01)),
          PeriodIncome(
              amount: 50,
              description: "Income 5",
              startingFrom: DateTime(2023, 03, 01)),
          PeriodIncome(
              amount: 50,
              description: "Income 7",
              startingFrom: DateTime(2023, 03, 01),
              applyUntil: DateTime(2023, 05, 01)),
        ]));
  });

  test(
      "Given detailed budget with income and expense, when request expense for a month, get only expenses still on going during that month",
      () {
    final result = budget.getActivePeriodExpenseFor(DateTime(2023, 03, 20));

    expect(
        result,
        unorderedEquals([
          PeriodExpense(
              amount: 50,
              description: "Expense 1",
              startingFrom: DateTime(2023, 01, 01)),
          PeriodExpense(
              amount: 50,
              description: "Expense 2",
              startingFrom: DateTime(2023, 01, 01),
              applyUntil: DateTime(2023, 03, 01)),
          PeriodExpense(
              amount: 50,
              description: "Expense 4",
              startingFrom: DateTime(2023, 03, 01),
              applyUntil: DateTime(2023, 03, 01)),
          PeriodExpense(
              amount: 50,
              description: "Expense 5",
              startingFrom: DateTime(2023, 03, 01)),
          PeriodExpense(
              amount: 50,
              description: "Expense 7",
              startingFrom: DateTime(2023, 03, 01),
              applyUntil: DateTime(2023, 05, 01)),
        ]));
  });
}
