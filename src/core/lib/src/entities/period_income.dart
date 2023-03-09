import 'package:equatable/equatable.dart';

class PeriodIncome extends Equatable {
  final double amount;
  final String description;
  const PeriodIncome({required this.amount, required this.description});

  @override
  List<Object?> get props => [amount, description];
}
