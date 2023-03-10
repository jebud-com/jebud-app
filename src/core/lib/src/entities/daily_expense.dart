import 'package:equatable/equatable.dart';

class DailyExpense extends Equatable {
  final double amount;
  final DateTime day;
  final String description;

  DailyExpense(
      {required this.amount, required this.day, required this.description});

  @override
  List<Object?> get props => [amount, day, description];
}
