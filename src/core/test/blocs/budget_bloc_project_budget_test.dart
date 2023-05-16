import 'package:core/core.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  final detailedBudget = DetailedBudget(
      budgetDetails: BudgetDetails(
          startingAmount: -400, startingMonth: DateTime(2023, 01, 01)),
      dailyExpenseAllocation: DailyExpensePeriodAllocation(amount: 200),
      incomes: [
        PeriodIncome(
          amount: 100,
          description: "Work 1",
          startingFrom: DateTime(2023, 01, 01),
        ),
        PeriodIncome(
            amount: 300,
            description: "Work 2",
            startingFrom: DateTime(2023, 03, 01),
            applyUntil: DateTime(2023, 06, 01))
      ],
      expenses: [
        PeriodExpense(
            amount: 50,
            startingFrom: DateTime(2023, 01, 01),
            description: "Car"),
        PeriodExpense(
            amount: 30,
            startingFrom: DateTime(2023, 04, 01),
            applyUntil: DateTime(2023, 06, 01),
            description: "Interest"),
        PeriodExpense(
            amount: 5,
            startingFrom: DateTime(2023, 05, 01),
            description: "Interest")
      ],
      dailyExpenses: [
        DailyExpense(
            amount: 10, day: DateTime(2023, 02, 10), description: "Pizza"),
        DailyExpense(
            amount: 300, day: DateTime(2023, 03, 11), description: "Monoprix 1"),
        DailyExpense(
            amount: 40, day: DateTime(2023, 04, 15), description: "Monoprix 2"),
        DailyExpense(
            amount: 340, day: DateTime(2023, 05, 15), description: "Monoprix 3")
      ]);

  test(
      "Given detailed budget, when projecting for the next month of starting month",
      () {
    final result = detailedBudget.projectBudget(
        from: DateTime(2023, 01, 01), to: DateTime(2023, 02, 01));
    expect(result, equals(-400 - 200 - 200 + 200 - 100));
  });

  test(
      "Given detailed budget, when projecting for the 3 month of starting month",
      () {
    final result = detailedBudget.projectBudget(
        from: DateTime(2023, 01, 01), to: DateTime(2023, 04, 01));

    expect(result, equals(-400 - 800 + 400 + 600 - 200 - 30));
  });

  test(
      "Given detailed budget, when projecting for the 3 month later and past daily expenses exist",
      () {
    final result = detailedBudget.projectBudget(
        from: DateTime(2023, 04, 01), to: DateTime(2023, 07, 01));

    expect(result, equals(-400 + 700 + 1200 - 350 - 90 - 15 - 10 - 300 - 800));
  });

  test(
      "Given detailed budget, when projecting for the 2 month later and current daily expenses surpassed limit",
      () {
    final result = detailedBudget.projectBudget(
        from: DateTime(2023, 05, 01), to: DateTime(2023, 07, 01));

    expect(result,
        equals(-400 + 700 + 1200 - 350 - 90 - 15 - 10 - 300 - 40 - 340 - 400));
  });
}
