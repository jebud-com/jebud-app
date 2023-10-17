import 'package:equatable/equatable.dart';

class PeriodIncome extends Equatable {
  final double amount;
  final String description;
  final DateTime startingFrom;
  late final DateTime applyUntil;

  PeriodIncome(
      {required this.amount,
      required this.description,
      required this.startingFrom,
      DateTime? applyUntil}) {
    this.applyUntil = applyUntil ?? DateTime(275760, 09, 13);
  }

  @override
  List<Object?> get props => [amount, description, startingFrom, applyUntil];
}
