import 'package:core/core.dart';
import 'package:infrastructure/src/utils.dart';
import 'package:isar/isar.dart';

part 'period_income_model.g.dart';

@collection
class PeriodIncomeModel extends HasIsarId implements MapsTo<PeriodIncome> {
  final double amount;
  final String description;
  final DateTime startingFrom;
  final DateTime applyUntil;

  PeriodIncomeModel(
      {required this.amount,
      required this.applyUntil,
      required this.description,
      required this.startingFrom});

  @ignore
  @override
  List<Object> get primaryKeyObjects => [amount, description, startingFrom];

  @override
  PeriodIncome toEntity() {
    return PeriodIncome(
        amount: amount,
        description: description,
        startingFrom: startingFrom,
        applyUntil: applyUntil);
  }

  factory PeriodIncomeModel.fromEntity(PeriodIncome income) =>
      PeriodIncomeModel(
          amount: income.amount,
          description: income.description,
          startingFrom: income.startingFrom,
          applyUntil: income.applyUntil);
}
