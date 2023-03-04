
import 'package:equatable/equatable.dart';

class PeriodExpense extends Equatable {
  final double amount;
  late final DateTime applyUntil;
  final DateTime startingFrom;
  PeriodExpense({required this.amount, DateTime? applyUntil, required this.startingFrom}){
    this.applyUntil = applyUntil ?? DateTime(275760, 09, 13);
  }

  @override
    List<Object?> get props => [
    amount,
    applyUntil,
    startingFrom
    ];
}
