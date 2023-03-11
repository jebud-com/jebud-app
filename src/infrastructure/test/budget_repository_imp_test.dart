import 'package:core/core.dart';
import 'package:infrastructure/src/budget_repository_impl.dart';
import 'package:infrastructure/src/models/budget_details_model.dart';
import 'package:infrastructure/src/models/daily_expense_model.dart';
import 'package:infrastructure/src/models/daily_expense_period_allocation_model.dart';
import 'package:infrastructure/src/models/period_expense_model.dart';
import 'package:infrastructure/src/models/period_income_model.dart';
import 'package:infrastructure/src/utils.dart';
import 'package:isar/isar.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  group("Add daily expense", () {
    BudgetRepositoryImpl budgetRepository = BudgetRepositoryImpl("isar");

    setUpAll(() async {
      await budgetRepository.init();
    });

    test("daily expense is saved", () async {
      final dailyExpense = DailyExpense(
          amount: 300, day: DateTime.parse("2023-01-01"), description: "pizza");
      await budgetRepository.addDailyExpense(dailyExpense);

      var isar = Isar.getInstance("isar")!;

      var savedDailyExpense = await isar.dailyExpenseModels.get(
          ("${300.0.toString()}${DateTime.parse("2023-01-01").toString()}pizza")
              .fastHash());

      expect(savedDailyExpense, isNotNull);
      expect(savedDailyExpense!.toEntity(), equals(dailyExpense));
    });

    test("daily expense allocation is saved", () async {
      final dailyExpenseAllocation = DailyExpensePeriodAllocation(amount: 400);
      await budgetRepository.addDailyExpenseAllocation(dailyExpenseAllocation);

      var isar = Isar.getInstance('isar')!;

      var savedDailyExpenseAllocation = await isar
          .dailyExpensePeriodAllocationModels
          .get("DailyExpensePeriodAllocation".fastHash());

      expect(savedDailyExpenseAllocation, isNotNull);
      expect(savedDailyExpenseAllocation!.toEntity(),
          equals(dailyExpenseAllocation));
    });

    test("period expense without end date is saved", () async {
      final periodExpense = PeriodExpense(
          amount: 400,
          description: "somethingElse",
          startingFrom: DateTime.parse("2023-03-11"));
      await budgetRepository.addPeriodExpense(periodExpense);

      var isar = Isar.getInstance('isar')!;

      var savedPeriodExpense = await isar.periodExpenseModels.get(
          (400.0.toString() +
                  "somethingElse".toString() +
                  DateTime.parse("2023-03-11").toString())
              .fastHash());

      expect(savedPeriodExpense, isNotNull);
      expect(savedPeriodExpense!.toEntity(), equals(periodExpense));
    });

    test("period expense with end date is saved", () async {
      final periodExpense = PeriodExpense(
          amount: 400,
          description: "somethingElse",
          startingFrom: DateTime.parse("2023-03-11"),
          applyUntil: DateTime.parse("2023-05-11"));
      await budgetRepository.addPeriodExpense(periodExpense);

      var isar = Isar.getInstance('isar')!;

      var savedPeriodExpense = await isar.periodExpenseModels.get(
          (400.0.toString() +
                  "somethingElse".toString() +
                  DateTime.parse("2023-03-11").toString())
              .fastHash());

      expect(savedPeriodExpense, isNotNull);
      expect(savedPeriodExpense!.toEntity(), equals(periodExpense));
    });

    test("period income is saved", () async {
      final periodIncome = PeriodIncome(
        amount: 400,
        description: "somethingElse",
      );
      await budgetRepository.addPeriodIncome(periodIncome);

      var isar = Isar.getInstance('isar')!;

      var savedPeriodIncome = await isar.periodIncomeModels
          .get((400.0.toString() + "somethingElse".toString()).fastHash());

      expect(savedPeriodIncome, isNotNull);
      expect(savedPeriodIncome!.toEntity(), equals(periodIncome));
    });

    test("budget details is saved", () async {
      final budgetDetails = BudgetDetails(
          startingAmount: 300, startingMonth: DateTime.parse("2023-03-01"));
      await budgetRepository.saveBudgetDetails(budgetDetails);

      var isar = Isar.getInstance('isar')!;

      var savedBudgetDetails = await isar.budgetDetailsModels.get(
          (300.0.toString() + DateTime.parse("2023-03-01").toString())
              .fastHash());

      expect(savedBudgetDetails, isNotNull);
      expect(savedBudgetDetails!.toEntity(), equals(budgetDetails));
    });
  });

  tearDownAll(() async {
    await Isar.getInstance("isar")!.close(deleteFromDisk: true);
  });
}
