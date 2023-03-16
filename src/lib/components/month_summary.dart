import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'budget_text.dart';
import 'summary_list.dart';

class MonthSummary extends StatefulWidget {
  const MonthSummary({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MonthSummaryState();
  }
}

class _MonthSummaryState extends State<MonthSummary> {
  final NumberFormat compactCurrencyFormatter =
      NumberFormat.compactCurrency(locale: "fr-fr", symbol: '€');

  final NumberFormat currencyFormatter =
      NumberFormat.currency(locale: "fr-fr", symbol: '€');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: BlocProvider.of<BudgetManagerBloc>(context),
        builder: (context, state) {
          DetailedBudget detailedBudget = state as DetailedBudget;
          return SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 64, left: 16, right: 16, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Hey there 👋",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox.square(dimension: 8),
                      Text(
                          "Here is your ${DateFormat.yMMMM("en-us").format(DateTime.now())} Budget Summary",
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox.square(dimension: 16),
                      Card(
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Savings by the end of the month",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18)),
                                Center(
                                    child: BudgetText(
                                  orangeBoundary: 500,
                                  nbrFormatter: currencyFormatter,
                                  budget: detailedBudget.estimateSavingsUpTo(
                                      DateTime.now().copyWith(day: 1)),
                                  fontSize: 32,
                                )),
                              ],
                            )),
                      ),
                      const SizedBox.square(dimension: 8),
                      const Text("Here is how much you can spend 💰",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox.square(dimension: 4),
                      SizedBox(
                        height: 85,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                                child: Card(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text("This month",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 14)),
                                            Center(
                                                child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: BudgetText(
                                                      orangeBoundary: 100,
                                                      nbrFormatter:
                                                          currencyFormatter,
                                                      budget: detailedBudget
                                                          .getLeftDailyExpenseForRunningMonth(
                                                              DateTime.now()),
                                                      fontSize: 26,
                                                    )))
                                          ],
                                        )))),
                            Expanded(
                                child: Card(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text("This week",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 14)),
                                            Center(
                                                child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: BudgetText(
                                                      orangeBoundary: 50,
                                                      nbrFormatter:
                                                          currencyFormatter,
                                                      budget: detailedBudget
                                                          .getLeftDailyExpenseForRunningWeek(
                                                              DateTime.now()),
                                                      fontSize: 26,
                                                    )))
                                          ],
                                        )))),
                            Expanded(
                                child: Card(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text("Today",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 14)),
                                            Center(
                                                child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: BudgetText(
                                                      orangeBoundary: 10,
                                                      nbrFormatter:
                                                          currencyFormatter,
                                                      budget: detailedBudget
                                                          .getLeftDailyExpenseForRunningDay(
                                                              DateTime.now()),
                                                      fontSize: 26,
                                                    )))
                                          ],
                                        )))),
                          ],
                        ),
                      ),
                      const SizedBox.square(dimension: 16),
                      SummaryList(
                          currencyFormatter: compactCurrencyFormatter,
                          title:
                              "💷 Daily expenses of ${DateFormat.yMMMMd("en-us").format(DateTime.now())}",
                          items: state
                              .getDailyExpensesForDay(DateTime.now())
                              .map((e) => SummaryItem(
                                  description: e.description, amount: e.amount))
                              .toList()),
                      const SizedBox.square(dimension: 16),
                      SummaryList(
                          currencyFormatter: compactCurrencyFormatter,
                          title: "📈 Monthly Incomes",
                          items: state.incomes
                              .map((e) => SummaryItem(
                                  description: e.description, amount: e.amount))
                              .toList()),
                      const SizedBox.square(dimension: 16),
                      SummaryList(
                          currencyFormatter: compactCurrencyFormatter,
                          title: "📉 Monthly Expenses",
                          items: state.expenses
                              .map((e) => SummaryItem(
                                  description: e.description, amount: e.amount))
                              .toList()),
                      const SizedBox.square(dimension: 16),
                      Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: const Text("⛅ Forecast for the future"),
                              subtitle:
                                  const Text("If you continue with this rate"),
                              children: [
                                ListTile(
                                    title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                      const Text('Next month'),
                                      Text(currencyFormatter.format(
                                          state.estimateSavingsUpTo(
                                              DateTime.now().copyWith(
                                                  month: DateTime.now().month +
                                                      1))))
                                    ])),
                                ListTile(
                                    title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                      const Text('3 months later'),
                                      Text(currencyFormatter.format(
                                          state.estimateSavingsUpTo(
                                              DateTime.now().copyWith(
                                                  month: DateTime.now().month +
                                                      3))))
                                    ])),
                                ListTile(
                                    title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                      const Text('6 months later'),
                                      Text(currencyFormatter.format(
                                          state.estimateSavingsUpTo(
                                              DateTime.now().copyWith(
                                                  month: DateTime.now().month +
                                                      6))))
                                    ])),
                                ListTile(
                                    title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                      const Text('1 year later'),
                                      Text(currencyFormatter.format(
                                          state.estimateSavingsUpTo(
                                              DateTime.now().copyWith(
                                                  year: DateTime.now().year +
                                                      1))))
                                    ])),
                              ],
                            )),
                      ),
                      const SizedBox.square(dimension: 40),
                    ],
                  )));
        });
  }
}
