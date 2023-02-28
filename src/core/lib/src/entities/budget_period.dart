class BudgetPeriod {
  final DateTime start;
  final DateTime end;

  const BudgetPeriod({required this.start, required this.end});

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is BudgetPeriod && other.start == start && other.end == end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
