import 'package:core/core.dart';
import 'package:infrastructure/src/utils.dart';
import 'package:isar/isar.dart';

part 'period_expense_model.g.dart';

@collection
class PeriodExpenseModel extends HasIsarId implements MapsTo<PeriodExpense> {
  final double amount;
  final String description;
  final DateTime applyUntil;
  final DateTime startingFrom;

  PeriodExpenseModel({required this.amount,
    required this.description,
    required this.startingFrom,
    required this.applyUntil});

  @ignore
  @override
  List<Object> get primaryKeyObjects => [amount, description, startingFrom];

  @override
  PeriodExpense toEntity() {
    return PeriodExpense(
        description: description,
        amount: amount,
        startingFrom: startingFrom,
        applyUntil: applyUntil);
  }

  factory PeriodExpenseModel.fromEntity(PeriodExpense periodExpense) =>
      PeriodExpenseModel(
          amount: periodExpense.amount, description: periodExpense.description,
          startingFrom: periodExpense.startingFrom,
          applyUntil: periodExpense.applyUntil);
}
