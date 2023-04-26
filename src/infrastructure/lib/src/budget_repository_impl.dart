import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:infrastructure/src/models/budget_details_model.dart';
import 'package:infrastructure/src/models/daily_expense_model.dart';
import 'package:infrastructure/src/models/daily_expense_period_allocation_model.dart';
import 'package:infrastructure/src/models/period_expense_model.dart';
import 'package:infrastructure/src/models/period_income_model.dart';
import 'package:isar/isar.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final String _connectionString;
  late final Isar _isarInstance;

  BudgetRepositoryImpl(this._connectionString);

  Future init() async {
    _isarInstance = await Isar.open([
      DailyExpenseModelSchema,
      DailyExpensePeriodAllocationModelSchema,
      PeriodExpenseModelSchema,
      PeriodIncomeModelSchema,
      BudgetDetailsModelSchema
    ], name: _connectionString);
  }

  @override
  Future addDailyExpense(DailyExpense dailyExpense) async {
    await _isarInstance.writeTxn(() async {
      await _isarInstance.dailyExpenseModels
          .put(DailyExpenseModel.fromEntity(dailyExpense));
    });
  }

  @override
  Future addDailyExpenseAllocation(
      DailyExpensePeriodAllocation dailyExpensePeriodAllocation) async {
    await _isarInstance.writeTxn(() async {
      await _isarInstance.dailyExpensePeriodAllocationModels.put(
          DailyExpensePeriodAllocationModel.fromEntity(
              dailyExpensePeriodAllocation));
    });
  }

  @override
  Future updateDailyExpenseAllocation(
      DailyExpensePeriodAllocation dailyExpensePeriodAllocation) async {
    await _isarInstance.writeTxn(() async {
      await _isarInstance.dailyExpensePeriodAllocationModels.put(
          DailyExpensePeriodAllocationModel.fromEntity(
              dailyExpensePeriodAllocation));
    });
  }

  @override
  Future addPeriodExpense(PeriodExpense periodExpense) async {
    await _isarInstance.writeTxn(() async {
      await _isarInstance.periodExpenseModels
          .put(PeriodExpenseModel.fromEntity(periodExpense));
    });
  }

  @override
  Future addPeriodIncome(PeriodIncome income) async {
    await _isarInstance.writeTxn(() async {
      await _isarInstance.periodIncomeModels
          .put(PeriodIncomeModel.fromEntity(income));
    });
  }

  @override
  Future saveBudgetDetails(BudgetDetails budgetDetails) async {
    await _isarInstance.writeTxn(() async {
      await _isarInstance.budgetDetailsModels
          .put(BudgetDetailsModel.fromEntity(budgetDetails));
    });
  }

  @override
  Future<Either<Failure, BudgetDetails>> getBudgetDetails() async {
    var budgetDetails =
        await _isarInstance.budgetDetailsModels.where().findFirst();
    if (budgetDetails == null) return Left(CannotFindBudgetDetails());
    return Right((budgetDetails.toEntity()));
  }

  @override
  Future<DailyExpensePeriodAllocation?> getDailyExpenseAllocation() async {
    return (await _isarInstance.dailyExpensePeriodAllocationModels
            .where()
            .findFirst())
        ?.toEntity();
  }

  @override
  Future<Iterable<DailyExpense>> getDailyExpenses() async {
    return (await _isarInstance.dailyExpenseModels.where().findAll())
        .map((e) => e.toEntity());
  }

  @override
  Future<Iterable<PeriodExpense>> getPeriodExpenses() async {
    return (await _isarInstance.periodExpenseModels.where().findAll())
        .map((e) => e.toEntity());
  }

  @override
  Future<Iterable<PeriodIncome>> getPeriodIncomes() async {
    return (await _isarInstance.periodIncomeModels.where().findAll())
        .map((e) => e.toEntity());
  }

  @override
  Future deleteDailyExpense(DailyExpense dailyExpense) async {
    await _isarInstance.writeTxn(() async => await _isarInstance
        .dailyExpenseModels
        .delete(DailyExpenseModel.fromEntity(dailyExpense).id));
  }
}
