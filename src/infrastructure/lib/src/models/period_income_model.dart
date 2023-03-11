import 'package:core/core.dart';
import 'package:infrastructure/src/utils.dart';
import 'package:isar/isar.dart';

part 'period_income_model.g.dart';

@collection
class PeriodIncomeModel extends HasIsarId implements MapsTo<PeriodIncome> {
  final double amount;
  final String description;

  PeriodIncomeModel({required this.amount, required this.description});

  @ignore
  @override
  List<Object> get primaryKeyObjects => [amount, description];

  @override
  PeriodIncome toEntity() {
    return PeriodIncome(amount: amount, description: description);
  }

  factory PeriodIncomeModel.fromEntity(PeriodIncome income) =>
      PeriodIncomeModel(amount: income.amount, description: income.description);
}
