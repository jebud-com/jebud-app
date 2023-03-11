import 'package:core/core.dart';
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
}
