import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:infrastructure/src/budget_repository_impl.dart';
import 'package:infrastructure/src/models/budget_details_model.dart';
import 'package:infrastructure/src/models/daily_expense_model.dart';
import 'package:infrastructure/src/models/daily_expense_period_allocation_model.dart';
import 'package:infrastructure/src/models/period_expense_model.dart';
import 'package:infrastructure/src/models/period_income_model.dart';
import 'package:isar/isar.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  group("queries", () {
    late BudgetRepositoryImpl budgetRepository;

    setUpAll(() async {
      budgetRepository = BudgetRepositoryImpl("isar");
      await budgetRepository.init();
    });

    test('budget details is retrieved', () async {
      var result = await budgetRepository.getBudgetDetails();

      result.fold((l) => expect(l, isA<CannotFindBudgetDetails>()),
          (r) => fail("Unexpected right side of either"));
    });

    test('budget details is retrieved', () async {
      var isar = Isar.getInstance('isar')!;

      await isar.writeTxn(() async {
        isar.budgetDetailsModels.put(BudgetDetailsModel(
            startingAmount: -500, startingMonth: DateTime.parse("2023-01-01")));
      });

      var result = await budgetRepository.getBudgetDetails();

      expect(
          result,
          Right(BudgetDetails(
              startingAmount: -500,
              startingMonth: DateTime.parse("2023-01-01"))));
    });

    test('daily expense allocation is not present', () async {
      var result = await budgetRepository.getDailyExpenseAllocation();

      expect(result, isNull);
    });

    test('daily expense allocation is retrieved', () async {
      var isar = Isar.getInstance('isar')!;

      await isar.writeTxn(() async {
        isar.dailyExpensePeriodAllocationModels
            .put(DailyExpensePeriodAllocationModel(amount: 400));
      });

      var result = await budgetRepository.getDailyExpenseAllocation();

      expect(result, DailyExpensePeriodAllocation(amount: 400));
    });

    test('incomes are not present', () async {
      var result = await budgetRepository.getPeriodIncomes();

      expect(result, <PeriodIncome>[]);
    });

    test('incomes are retrieved', () async {
      var isar = Isar.getInstance('isar')!;

      await isar.writeTxn(() async {
        isar.periodIncomeModels
            .put(PeriodIncomeModel(amount: 100, description: "something"));
        isar.periodIncomeModels
            .put(PeriodIncomeModel(amount: 500, description: "something else"));
      });

      var result = await budgetRepository.getPeriodIncomes();

      expect(result, <PeriodIncome>[
        PeriodIncome(amount: 100, description: "something"),
        PeriodIncome(amount: 500, description: "something else"),
      ]);
    });

    test('expenses are not present', () async {
      var result = await budgetRepository.getPeriodExpenses();

      expect(result, <PeriodExpense>[]);
    });

    test('expenses are retrieved', () async {
      var isar = Isar.getInstance('isar')!;

      await isar.writeTxn(() async {
        isar.periodExpenseModels.put(PeriodExpenseModel(
            amount: 100,
            description: "something",
            startingFrom: DateTime.parse("2023-01-05"),
            applyUntil: DateTime(275760, 09, 13)));
        isar.periodExpenseModels.put(PeriodExpenseModel(
            amount: 500,
            description: "something else",
            startingFrom: DateTime.parse("2023-06-12"),
            applyUntil: DateTime.parse("2023-06-30")));
      });

      var result = await budgetRepository.getPeriodExpenses();

      expect(result, <PeriodExpense>[
        PeriodExpense(
          amount: 100,
          description: "something",
          startingFrom: DateTime.parse("2023-01-05"),
        ),
        PeriodExpense(
            amount: 500,
            description: "something else",
            startingFrom: DateTime.parse("2023-06-12"),
            applyUntil: DateTime.parse("2023-06-30"))
      ]);
    });

    test("daily expenses are not present", () async {
      var result = await budgetRepository.getDailyExpenses();
      expect(result, []);
    });

    test("daily expenses are retrieved", () async {
      var isar = Isar.getInstance('isar')!;

      await isar.writeTxn(() async {
        isar.dailyExpenseModels.put(DailyExpenseModel(
          amount: 100,
          description: "something",
          day: DateTime.parse("2023-01-05"),
        ));
        isar.dailyExpenseModels.put(DailyExpenseModel(
          amount: 500,
          description: "something else",
          day: DateTime.parse("2023-06-12"),
        ));
      });

      var result = await budgetRepository.getDailyExpenses();
      expect(result, [
        DailyExpense(
          amount: 100,
          description: "something",
          day: DateTime.parse("2023-01-05"),
        ),
        DailyExpense(
          amount: 500,
          description: "something else",
          day: DateTime.parse("2023-06-12"),
        )
      ]);
    });

    tearDown(() async {
      var isar = Isar.getInstance('isar')!;
      await isar.writeTxn(() async {
        await isar.clear();
      });
    });
  });

  tearDownAll(() async {
    await Isar.getInstance("isar")!.close(deleteFromDisk: true);
  });
}
