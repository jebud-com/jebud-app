import 'package:core/core.dart';
import 'package:isar/isar.dart';
import '../utils.dart';

part 'daily_expense_period_allocation_model.g.dart';

@collection
class DailyExpensePeriodAllocationModel extends HasIsarId implements MapsTo<DailyExpensePeriodAllocation> {
  final double amount;

  DailyExpensePeriodAllocationModel({required this.amount});

  @ignore
  @override
  List<Object> get primaryKeyObjects => ["DailyExpensePeriodAllocation"];

  @override
  DailyExpensePeriodAllocation toEntity() =>
      DailyExpensePeriodAllocation(amount: amount);

  factory DailyExpensePeriodAllocationModel.fromEntity(
      DailyExpensePeriodAllocation dailyExpensePeriodAllocation) {
    return DailyExpensePeriodAllocationModel(
        amount: dailyExpensePeriodAllocation.amount);
  }
}
