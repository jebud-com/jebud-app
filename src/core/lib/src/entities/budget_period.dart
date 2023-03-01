import 'package:equatable/equatable.dart';

class BudgetPeriod extends Equatable {
  final DateTime start;
  final DateTime end;

  const BudgetPeriod({required this.start, required this.end});

  @override
  List<Object?> get props => [start, end];
}
