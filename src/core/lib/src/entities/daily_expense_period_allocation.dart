class DailyExpensePeriodAllocation {
  final double amount;

  DailyExpensePeriodAllocation({required this.amount});

  factory DailyExpensePeriodAllocation.zero() =>
      DailyExpensePeriodAllocation(amount: 0);
}
