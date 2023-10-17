import 'package:equatable/equatable.dart';

class DailyExpensePeriodAllocation extends Equatable {
  final double amount;

  DailyExpensePeriodAllocation({required this.amount});

  factory DailyExpensePeriodAllocation.zero() =>
      DailyExpensePeriodAllocation(amount: 0);

  @override
  List<Object?> get props => [amount];
}
