import 'package:core/core.dart';
import 'package:core/src/projections.dart';
import 'package:test/test.dart';

void main() {
  group("Calculate whatIf expense of 300 for different projections", () {
    late DetailedBudget detailedBudget;

    setUp(() {
      detailedBudget = DetailedBudget(
          budgetDetails: BudgetDetails(
              startingAmount: 500, startingMonth: DateTime.parse("2023-03-01")),
          incomes: [
            PeriodIncome(
                amount: 300,
                description: '',
                startingFrom: DateTime.parse("2023-03-01"))
          ],
          expenses: [
            PeriodExpense(
                amount: 40,
                startingFrom: DateTime.parse("2023-03-01"),
                description: 'subscription'),
            PeriodExpense(
                description: 'netflix',
                amount: 10,
                startingFrom: DateTime.parse("2023-05-01"),
                applyUntil: DateTime.parse("2023-07-01"))
          ]);
    });

    test('Calculated a WhatIf expense for current Month', () {
      var result = detailedBudget.estimateWhatIfISpend(
          amount: 200,
          startingFrom: DateTime.parse("2023-03-01"),
          until: DateTime.parse("2023-07-01"),
          projectFor: Projections.oneMonth);

      expect(result, equals(560));
    });

    test('Calculated a WhatIf expense for next three months', () {
      var result = detailedBudget.estimateWhatIfISpend(
          amount: 200,
          startingFrom: DateTime.parse("2023-03-01"),
          until: DateTime.parse("2023-07-01"),
          projectFor: Projections.threeMonths);

      expect(result, equals(670));
    });

    test('Calculated a WhatIf expense for next six months', () {
      var result = detailedBudget.estimateWhatIfISpend(
          amount: 200,
          startingFrom: DateTime.parse("2023-03-01"),
          until: DateTime.parse("2023-07-01"),
          projectFor: Projections.sixMonths);

      expect(result, equals(1030));
    });

    test('Calculated a WhatIf expense for one year months', () {
      var result = detailedBudget.estimateWhatIfISpend(
          amount: 200,
          startingFrom: DateTime.parse("2023-03-01"),
          until: DateTime.parse("2023-07-01"),
          projectFor: Projections.oneYear);

      expect(result, equals(2590));
    });

    test(
        'Calculated a WhatIf expense for next three six but the expense starts two months later',
        () {
      var result = detailedBudget.estimateWhatIfISpend(
          amount: 200,
          startingFrom: DateTime.parse("2023-05-01"),
          until: DateTime.parse("2023-07-01"),
          projectFor: Projections.sixMonths);

      expect(result, equals(1430));
    });
  });
}
