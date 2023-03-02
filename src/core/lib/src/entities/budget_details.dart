import 'package:equatable/equatable.dart';

class BudgetDetails extends Equatable {
  final double startingAmount;
  final DateTime startingMonth;

  BudgetDetails({required this.startingAmount, required this.startingMonth});

  @override
  List<Object?> get props => [startingAmount, startingMonth];
}
