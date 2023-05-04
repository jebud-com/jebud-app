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
  const String connectionString = "commands";
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  group("commands", () {
    late BudgetRepositoryImpl budgetRepository;

    setUpAll(() async {
      budgetRepository = BudgetRepositoryImpl(connectionString);
      await budgetRepository.init();
    });

    test("daily expense is saved", () async {
      final dailyExpense = DailyExpense(
          amount: 300, day: DateTime.parse("2023-01-01"), description: "pizza");
      await budgetRepository.addDailyExpense(dailyExpense);

      var isar = Isar.getInstance(connectionString)!;

      var savedDailyExpense = await isar.dailyExpenseModels.get(
          ("${300.0.toString()}${DateTime.parse("2023-01-01").toString()}pizza")
              .fastHash());

      expect(savedDailyExpense, isNotNull);
      expect(savedDailyExpense!.toEntity(), equals(dailyExpense));
    });

    test("daily expense is deleted", () async {
      final dailyExpenseToDelete = DailyExpense(
          amount: 40, day: DateTime.now(), description: "Monoprix");

      var isar = Isar.getInstance(connectionString)!;
      await isar.writeTxn(() async => await isar.dailyExpenseModels
          .put(DailyExpenseModel.fromEntity(dailyExpenseToDelete)));

      await budgetRepository.deleteDailyExpense(dailyExpenseToDelete);

      var deleteDailyExpense = await isar.dailyExpenseModels.get(
          "${dailyExpenseToDelete.amount.toString()}${dailyExpenseToDelete.day}${dailyExpenseToDelete.description}"
              .fastHash());

      expect(deleteDailyExpense, equals(null));
    });

    test("daily expense allocation is saved", () async {
      final dailyExpenseAllocation = DailyExpensePeriodAllocation(amount: 400);
      await budgetRepository.addDailyExpenseAllocation(dailyExpenseAllocation);

      var isar = Isar.getInstance(connectionString)!;

      var savedDailyExpenseAllocation = await isar
          .dailyExpensePeriodAllocationModels
          .get("DailyExpensePeriodAllocation".fastHash());

      expect(savedDailyExpenseAllocation, isNotNull);
      expect(savedDailyExpenseAllocation!.toEntity(),
          equals(dailyExpenseAllocation));
    });

    test("daily expense allocation is updated", () async {
      var isar = Isar.getInstance(connectionString)!;

      await isar.writeTxn(() async => await isar
          .dailyExpensePeriodAllocationModels
          .put(DailyExpensePeriodAllocationModel(amount: 0)));

      final newDailyExpenseAllocation =
          DailyExpensePeriodAllocation(amount: 400);
      await budgetRepository
          .updateDailyExpenseAllocation(newDailyExpenseAllocation);

      var newlySavedDailyExpenseAllocation = await isar
          .dailyExpensePeriodAllocationModels
          .get("DailyExpensePeriodAllocation".fastHash());

      expect(newlySavedDailyExpenseAllocation, isNotNull);
      expect(newlySavedDailyExpenseAllocation!.toEntity(),
          equals(newDailyExpenseAllocation));
    });

    test("period expense without end date is saved", () async {
      final periodExpense = PeriodExpense(
          amount: 400,
          description: "somethingElse",
          startingFrom: DateTime.parse("2023-03-11"));
      await budgetRepository.addPeriodExpense(periodExpense);

      var isar = Isar.getInstance(connectionString)!;

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

      var isar = Isar.getInstance(connectionString)!;

      var savedPeriodExpense = await isar.periodExpenseModels.get(
          (400.0.toString() +
                  "somethingElse".toString() +
                  DateTime.parse("2023-03-11").toString())
              .fastHash());

      expect(savedPeriodExpense, isNotNull);
      expect(savedPeriodExpense!.toEntity(), equals(periodExpense));
    });

    group("period income is saved", () {
      test("period income is saved", () async {
        final periodIncome = PeriodIncome(
            amount: 400,
            description: "somethingElse",
            startingFrom: DateTime.parse("2023-01-23"));
        await budgetRepository.addPeriodIncome(periodIncome);

        var isar = Isar.getInstance(connectionString)!;

        var savedPeriodIncome = await isar.periodIncomeModels.get(
            (400.0.toString() +
                    "somethingElse".toString() +
                    DateTime.parse("2023-01-23").toString())
                .fastHash());

        expect(savedPeriodIncome, isNotNull);
        expect(savedPeriodIncome!.toEntity(), equals(periodIncome));
      });

      test("period income is saved with end date", () async {
        final periodIncome = PeriodIncome(
            amount: 400,
            description: "withEnd",
            startingFrom: DateTime.parse("2023-01-23"),
            applyUntil: DateTime.parse("2023-06-23"));
        await budgetRepository.addPeriodIncome(periodIncome);

        var isar = Isar.getInstance(connectionString)!;

        var savedPeriodIncome = await isar.periodIncomeModels.get(
            (400.0.toString() +
                    "withEnd".toString() +
                    DateTime.parse("2023-01-23").toString())
                .fastHash());

        expect(savedPeriodIncome, isNotNull);
        expect(savedPeriodIncome!.toEntity(), equals(periodIncome));
      });
    });

    test("budget details is saved", () async {
      final budgetDetails = BudgetDetails(
          startingAmount: 300, startingMonth: DateTime.parse("2023-03-01"));
      await budgetRepository.saveBudgetDetails(budgetDetails);

      var isar = Isar.getInstance(connectionString)!;

      var savedBudgetDetails = await isar.budgetDetailsModels.get(
          (300.0.toString() + DateTime.parse("2023-03-01").toString())
              .fastHash());

      expect(savedBudgetDetails, isNotNull);
      expect(savedBudgetDetails!.toEntity(), equals(budgetDetails));
    });

    test(
        "Given a period income, when deleting it, then it shouldn't exist in the db",
        () async {
      PeriodIncome periodIncome = PeriodIncome(
          amount: 24, description: "Monoprix", startingFrom: DateTime.now());

      Isar isar = Isar.getInstance(connectionString)!;

      var model = PeriodIncomeModel.fromEntity(periodIncome);
      isar.writeTxn(() => isar.periodIncomeModels.put(model));

      await budgetRepository.permanentlyDeletePeriodIncome(periodIncome);

      var deletedPeriodIncome = await isar.periodIncomeModels.get(model.id);

      expect(deletedPeriodIncome, equals(null));
    });

    test(
        "Given a period income, when updating it, then it should be updated in the db",
        () async {
      PeriodIncome periodIncome = PeriodIncome(
          amount: 24, description: "Monoprix", startingFrom: DateTime.now());

      Isar isar = Isar.getInstance(connectionString)!;

      var model = PeriodIncomeModel.fromEntity(periodIncome);
      await isar.writeTxn(() => isar.periodIncomeModels.put(model));

      var updatedPeriodIncome = PeriodIncome(
          amount: periodIncome.amount,
          description: periodIncome.description,
          startingFrom: periodIncome.startingFrom,
          applyUntil: DateTime.now());

      await budgetRepository.updatePeriodIncome(updatedPeriodIncome);

      var updatedPeriodIncomeFromDb =
          (await isar.periodIncomeModels.get(model.id))!.toEntity();

      expect(updatedPeriodIncomeFromDb, equals(updatedPeriodIncome));
    });

    tearDown(() async {
      var isar = Isar.getInstance(connectionString)!;
      await isar.writeTxn(() async {
        await isar.clear();
      });
    });
  });

  tearDownAll(() async {
    await Isar.getInstance(connectionString)!.close(deleteFromDisk: true);
  });
}
