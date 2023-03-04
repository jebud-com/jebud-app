
class PeriodExpense {
  final double amount;
  late final DateTime applyUntil;
  final DateTime startingFrom;
  PeriodExpense({required this.amount, DateTime? applyUntil, required this.startingFrom}){
    this.applyUntil = applyUntil ?? DateTime(275760, 09, 13);
  }
}
