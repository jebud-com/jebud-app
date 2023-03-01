import 'package:equatable/equatable.dart';

class PeriodIncome extends Equatable {
  final double amount;
  const PeriodIncome({required this.amount});

  @override
  List<Object?> get props => [amount];
}
