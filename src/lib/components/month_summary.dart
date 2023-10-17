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
                                  budget: detailedBudget
                                      .estimateSavingsUpTo(DateTime.now()),
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
                      SummaryList<DailyExpense>(
                        currencyFormatter: compactCurrencyFormatter,
                        title:
                            "💷 Daily expenses of ${DateFormat.yMMMMd("en-us").format(DateTime.now())}",
                        onDelete: (dailyExpense) async {
                          return await showDialog(
                                  context: context,
                                  builder: (context) => deleteDialog(
                                      "Are you sure you want to delete the daily expense ${dailyExpense.description} of ${compactCurrencyFormatter.format(dailyExpense.amount)}",
                                      () => BlocProvider.of<BudgetManagerBloc>(
                                              context)
                                          .add(
                                              DeleteDailyExpense(dailyExpense)),
                                      (previous, current) =>
                                          previous.isDeletingDailyExpense &&
                                          !current.isDeletingDailyExpense)) ??
                              false;
                        },
                        items: state.getDailyExpensesForDay(DateTime.now()),
                        toSummaryTile: (e) => SummaryItem(
                            description: e.description, amount: e.amount),
                      ),
                      const SizedBox.square(dimension: 16),
                      SummaryList<PeriodIncome>(
                          currencyFormatter: compactCurrencyFormatter,
                          onDelete: (periodIncome) async {
                            return await showDialog(
                                    context: context,
                                    builder: (context) => deleteDialog(
                                        "Are you sure you want to delete the  periodic income ${periodIncome.description} of ${compactCurrencyFormatter.format(periodIncome.amount)}",
                                        () => BlocProvider.of<
                                                BudgetManagerBloc>(context)
                                            .add(PermanentlyDeletePeriodIncome(
                                                periodIncome)),
                                        (previous, current) =>
                                            previous
                                                .isPermanentlyDeletingPeriodIncome &&
                                            !current
                                                .isPermanentlyDeletingPeriodIncome)) ??
                                false;
                          },
                          onStop: (periodIncome) async {
                            return await showDialog(
                                    context: context,
                                    builder: (context) {
                                      DateTime selectedDateTime =
                                          DateTime.now();
                                      return BlocListener(
                                          bloc: BlocProvider.of<
                                              BudgetManagerBloc>(context),
                                          listener: (context, state) {
                                            Navigator.pop(context, false);
                                          },
                                          listenWhen: (previous, current) =>
                                              previous is DetailedBudget &&
                                              current is DetailedBudget &&
                                              previous.isStoppingPeriodIncome &&
                                              !current.isStoppingPeriodIncome,
                                          child: AlertDialog(
                                            title: const Text(
                                                "When Do You want to stop?"),
                                            content: SizedBox(
                                                width: 300,
                                                height: 300,
                                                child: CalendarDatePicker(
                                                    initialDate: DateTime.now(),
                                                    firstDate: periodIncome
                                                        .startingFrom,
                                                    lastDate: DateTime(
                                                        275760, 09, 13),
                                                    onDateChanged:
                                                        (newDateTime) {
                                                      selectedDateTime =
                                                          newDateTime;
                                                    })),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, false);
                                                  },
                                                  child: const Text("Cancel")),
                                              TextButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                BudgetManagerBloc>(
                                                            context)
                                                        .add(StopPeriodIncome(
                                                            periodIncome,
                                                            at: selectedDateTime));
                                                  },
                                                  child: const Text("Done!"))
                                            ],
                                          ));
                                    }) ??
                                false;
                          },
                          title: "📈 Monthly Incomes",
                          items: state.getActivePeriodIncomeFor(DateTime.now()),
                          toSummaryTile: (e) => SummaryItem(
                              description: e.description, amount: e.amount)),
                      const SizedBox.square(dimension: 16),
                      SummaryList<PeriodExpense>(
                        currencyFormatter: compactCurrencyFormatter,
                        title: "📉 Monthly Expenses",
                        onDelete: (periodExpense) async {
                          return await showDialog(
                                  context: context,
                                  builder: (context) => deleteDialog(
                                      "Are you sure you want to delete the periodic expense ${periodExpense.description} of ${compactCurrencyFormatter.format(periodExpense.amount)}",
                                      () => BlocProvider.of<BudgetManagerBloc>(
                                              context)
                                          .add(PermanentlyDeletePeriodExpense(
                                              periodExpense)),
                                      (previous, current) =>
                                          previous
                                              .isPermanentlyDeletingPeriodExpense &&
                                          !current
                                              .isPermanentlyDeletingPeriodExpense)) ??
                              false;
                        },
                        onStop: (periodExpense) async {
                          return await showDialog(
                                  context: context,
                                  builder: (context) {
                                    DateTime selectedDateTime = DateTime.now();
                                    return BlocListener(
                                        bloc:
                                            BlocProvider.of<BudgetManagerBloc>(
                                                context),
                                        listener: (context, state) {
                                          Navigator.pop(context, false);
                                        },
                                        listenWhen: (previous, current) =>
                                            previous is DetailedBudget &&
                                            current is DetailedBudget &&
                                            previous.isStoppingPeriodExpense &&
                                            !current.isStoppingPeriodExpense,
                                        child: AlertDialog(
                                          title: const Text(
                                              "When Do You want to stop?"),
                                          content: SizedBox(
                                              width: 300,
                                              height: 300,
                                              child: CalendarDatePicker(
                                                  initialDate: DateTime.now(),
                                                  firstDate: periodExpense
                                                      .startingFrom,
                                                  lastDate:
                                                      DateTime(275760, 09, 13),
                                                  onDateChanged: (newDateTime) {
                                                    selectedDateTime =
                                                        newDateTime;
                                                  })),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: const Text("Cancel")),
                                            TextButton(
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              BudgetManagerBloc>(
                                                          context)
                                                      .add(StopPeriodExpense(
                                                          periodExpense,
                                                          at: selectedDateTime));
                                                },
                                                child: const Text("Done!"))
                                          ],
                                        ));
                                  }) ??
                              false;
                        },
                        items: state.getActivePeriodExpenseFor(DateTime.now()),
                        toSummaryTile: (e) => SummaryItem(
                            description: e.description, amount: e.amount),
                      ),
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
                                      Text(
                                          'Next month (${DateFormat.yM("en-us").format(DateTime.now().copyWith(month: DateTime.now().month + 1))})'),
                                      Text(currencyFormatter.format(
                                          state.projectBudget(
                                              from: DateTime.now(),
                                              to: DateTime.now().copyWith(
                                                  month: DateTime.now().month +
                                                      1))))
                                    ])),
                                ListTile(
                                    title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                      Text(
                                          '2nd Next month (${DateFormat.yM("en-us").format(DateTime.now().copyWith(month: DateTime.now().month + 2))})'),
                                      Text(currencyFormatter.format(
                                          state.projectBudget(
                                              from: DateTime.now(),
                                              to: DateTime.now().copyWith(
                                                  month: DateTime.now().month +
                                                      2))))
                                    ])),
                                ListTile(
                                    title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                      Text(
                                          '3 months later (${DateFormat.yM("en-us").format(DateTime.now().copyWith(month: DateTime.now().month + 3))})'),
                                      Text(currencyFormatter.format(
                                          state.projectBudget(
                                              from: DateTime.now(),
                                              to: DateTime.now().copyWith(
                                                  month: DateTime.now().month +
                                                      3))))
                                    ])),
                                ListTile(
                                    title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                      Text(
                                          '6 months later (${DateFormat.yM("en-us").format(DateTime.now().copyWith(month: DateTime.now().month + 6))})'),
                                      Text(currencyFormatter.format(
                                          state.projectBudget(
                                              from: DateTime.now(),
                                              to: DateTime.now().copyWith(
                                                  month: DateTime.now().month +
                                                      6))))
                                    ])),
                                ListTile(
                                    title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                      Text(
                                          '1 year later (${DateFormat.yM("en-us").format(DateTime.now().copyWith(year: DateTime.now().year + 1))})'),
                                      Text(currencyFormatter.format(
                                          state.projectBudget(
                                              from: DateTime.now(),
                                              to: DateTime.now().copyWith(
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

  Widget deleteDialog(
      String content,
      VoidCallback delete,
      bool Function(DetailedBudget previous, DetailedBudget current)
          dismissWhen) {
    return BlocListener(
        bloc: BlocProvider.of<BudgetManagerBloc>(context),
        listenWhen: (previous, current) {
          return previous is DetailedBudget &&
              current is DetailedBudget &&
              dismissWhen(previous, current);
        },
        listener: (context, state) {
          if (state is DetailedBudget && !state.isDeletingDailyExpense) {
            Navigator.pop(context, true);
          }
        },
        child: AlertDialog(
          title: const Text("Do you confirm?"),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  delete();
                },
                child: const Text("Sure!")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Nope")),
          ],
        ));
  }
}
