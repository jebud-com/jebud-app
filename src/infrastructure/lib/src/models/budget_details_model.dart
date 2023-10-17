import 'package:core/core.dart';
import 'package:infrastructure/src/utils.dart';
import 'package:isar/isar.dart';

part 'budget_details_model.g.dart';

@collection
class BudgetDetailsModel extends HasIsarId implements MapsTo<BudgetDetails> {
  final double startingAmount;
  final DateTime startingMonth;

  BudgetDetailsModel(
      {required this.startingAmount, required this.startingMonth});

  @override
  BudgetDetails toEntity() {
    return BudgetDetails(
        startingAmount: startingAmount, startingMonth: startingMonth);
  }

  @ignore
  @override
  List<Object> get primaryKeyObjects => [startingAmount, startingMonth];

  factory BudgetDetailsModel.fromEntity(BudgetDetails budgetDetails) =>
      BudgetDetailsModel(
          startingAmount: budgetDetails.startingAmount,
          startingMonth: budgetDetails.startingMonth);
}
