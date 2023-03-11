import 'package:core/core.dart';
import 'package:infrastructure/src/utils.dart';
import 'package:isar/isar.dart';

part 'daily_expense_model.g.dart';

@collection
class DailyExpenseModel extends HasIsarId implements MapsTo<DailyExpense> {
  final double amount;
  final DateTime day;
  final String description;

  DailyExpenseModel(
      {required this.amount, required this.day, required this.description});
  
  @override
  DailyExpense toEntity() =>
      DailyExpense(amount: amount, day: day, description: description);

  factory DailyExpenseModel.fromEntity(DailyExpense entity) =>
      DailyExpenseModel(
          amount: entity.amount,
          day: entity.day,
          description: entity.description);

  @ignore
  @override
  List<Object> get primaryKeyObjects => [amount, day, description];
}

