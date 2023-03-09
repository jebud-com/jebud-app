import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:core/src/entities/budget_details.dart';
import 'package:core/src/entities/daily_expense_period_allocation.dart';
import 'package:core/src/entities/period_expense.dart';
import 'package:core/src/interfaces/date_time_service.dart';
import 'package:core/src/repository/budget_repository.dart';
import 'package:equatable/equatable.dart';

import '../entities/daily_expense.dart';
import '../entities/period_income.dart';
import '../projections.dart';

class BudgetManagerBlocState {}

class BudgetManagerBlocEvent {}

class BudgetManagerBloc
    extends Bloc<BudgetManagerBlocEvent, BudgetManagerBlocState> {
  final BudgetRepository _budgetRepository;
  final DateTimeService _dateTimeService;

  BudgetManagerBloc(this._budgetRepository, this._dateTimeService)
      : super(UninitializedBudget()) {
    on<SetupBudgetDetails>(_setupBudgetDetails);
    on<AddPeriodIncome>(_addPeriodIncome);
    on<AddPeriodExpense>(_addPeriodExpense);
  }

  void _setupBudgetDetails(SetupBudgetDetails event, Emitter emit) async {
    emit(InitializingBudget());
    var details = BudgetDetails(
        startingAmount: event.startingAmount,
        startingMonth: _dateTimeService.startOfCurrentMonth);
    await _budgetRepository.saveBudgetDetails(details);
    emit(DetailedBudget(budgetDetails: details));
  }

  void _addPeriodIncome(AddPeriodIncome event, Emitter emit) async {
    emit(DetailedBudget.copyFromWith(state as DetailedBudget,
        isAddingIncome: true));

    final income =
        PeriodIncome(amount: event.amount, description: event.description);
    await _budgetRepository.addPeriodIncome(income);

    final currentDetailedBudget = (state as DetailedBudget);
    emit(DetailedBudget.copyFromWith(state as DetailedBudget,
        isAddingIncome: false,
        incomes: [...currentDetailedBudget.incomes, income]));
  }

  void _addPeriodExpense(AddPeriodExpense event, Emitter emit) async {
    final currentDetailedBudget = (state as DetailedBudget);
    emit(DetailedBudget.copyFromWith(currentDetailedBudget,
        isAddingExpense: true));

    final expense = PeriodExpense(
        amount: event.amount,
        description: event.description,
        startingFrom:
            event.startingFrom ?? _dateTimeService.startOfCurrentMonth,
        applyUntil: event.applyUntil);
    await _budgetRepository.addPeriodExpense(expense);

    emit(DetailedBudget.copyFromWith(currentDetailedBudget,
        isAddingExpense: false,
        expenses: [...currentDetailedBudget.expenses, expense]));
  }
}

class UninitializedBudget extends BudgetManagerBlocState {}

class InitializingBudget extends BudgetManagerBlocState {}

class DetailedBudget extends Equatable implements BudgetManagerBlocState {
  final BudgetDetails budgetDetails;
  late final List<PeriodIncome> incomes;
  late final List<DailyExpense> _dailyExpenses;
  late final List<PeriodExpense> expenses;
  late final DailyExpensePeriodAllocation dailyExpenseAllocation;
  final bool isAddingIncome;
  final bool isAddingExpense;

  DetailedBudget(
      {required this.budgetDetails,
      List<PeriodIncome>? incomes,
      List<PeriodExpense>? expenses,
      this.isAddingIncome = false,
      this.isAddingExpense = false,
      DailyExpensePeriodAllocation? dailyExpenseAllocation}) {
    this.incomes = incomes ?? [];
    this.expenses = expenses ?? [];
    _dailyExpenses = [];
    this.dailyExpenseAllocation =
        dailyExpenseAllocation ?? DailyExpensePeriodAllocation.zero();
  }

  DetailedBudget._internal(
      {required this.budgetDetails,
      required this.incomes,
      required this.expenses,
      required List<DailyExpense> dailyExpenses,
      required this.isAddingIncome,
      required this.isAddingExpense,
      required this.dailyExpenseAllocation}) {
    _dailyExpenses = dailyExpenses;
  }

  factory DetailedBudget.copyFromWith(DetailedBudget oldDetailedBudget,
          {List<PeriodIncome>? incomes,
          List<PeriodExpense>? expenses,
          bool? isAddingExpense,
          List<DailyExpense>? dailyExpenses,
          bool? isAddingIncome}) =>
      DetailedBudget._internal(
          budgetDetails: oldDetailedBudget.budgetDetails,
          incomes: incomes ?? oldDetailedBudget.incomes,
          expenses: expenses ?? oldDetailedBudget.expenses,
          dailyExpenseAllocation: oldDetailedBudget.dailyExpenseAllocation,
          dailyExpenses: dailyExpenses ?? oldDetailedBudget._dailyExpenses,
          isAddingExpense: isAddingExpense ?? oldDetailedBudget.isAddingExpense,
          isAddingIncome: isAddingIncome ?? oldDetailedBudget.isAddingIncome);

  @override
  List<Object?> get props =>
      [budgetDetails, incomes, isAddingIncome, isAddingExpense, expenses];

  double estimateSavingsUpTo(DateTime targetMonth) {
    if (budgetDetails.startingMonth.isAfter(targetMonth)) return 0;

    double result = budgetDetails.startingAmount;
    var startMonth = budgetDetails.startingMonth;

    final totalIncomes =
        incomes.fold(0.0, (value, element) => value + element.amount);

    for (int i = 0; i < _numberOfMonthsToTargetMonth(targetMonth); i++) {
      final currentMonth =
          DateTime(startMonth.year, startMonth.month + i, startMonth.day);
      result = result + totalIncomes;
      result = result - _expensesFor(currentMonth);
    }

    final maxBetweenAllocationAndTotalExpensesOfTheMonth = max(
        dailyExpenseAllocation.amount,
        _dailyExpenses
            .where((element) =>
                element.day.month == targetMonth.month &&
                element.day.year == targetMonth.year)
            .fold(0.0, (value, element) => value + element.amount));

    final allEarlierExpenses = _dailyExpenses
        .where((element) =>
            element.day.month < targetMonth.month &&
            element.day.year <= targetMonth.year)
        .fold(0.0, (value, element) => value + element.amount);

    return result -
        maxBetweenAllocationAndTotalExpensesOfTheMonth -
        allEarlierExpenses;
  }

  double _expensesFor(DateTime month) {
    return expenses.fold(0.0, (value, element) {
      if (element.applyUntil.isAtSameMomentAs(month) ||
          element.startingFrom.isAtSameMomentAs(month) ||
          element.applyUntil.isAfter(month) &&
              element.startingFrom.isBefore(month)) {
        return value + element.amount;
      }
      return value;
    });
  }

  int _numberOfMonthsToTargetMonth(DateTime targetMonth) {
    return _numberOfMonthsBetweenInclusiveEnds(
        budgetDetails.startingMonth, targetMonth);
  }

  int _numberOfMonthsBetweenInclusiveEnds(
      DateTime startMonth, DateTime endMonth) {
    final startingMonth = budgetDetails.startingMonth;
    final firstDayOfTargetMonth = DateTime(endMonth.year, endMonth.month, 1);

    final yearDifference = firstDayOfTargetMonth.year - startingMonth.year;

    return (firstDayOfTargetMonth.month - startingMonth.month) +
        DateTime.monthsPerYear * yearDifference +
        1;
  }

  int _numberOfMonthsBetweenOneExclusiveEnd(
      DateTime startMonth, DateTime endMonth) {
    final startingMonth = budgetDetails.startingMonth;
    final firstDayOfTargetMonth = DateTime(endMonth.year, endMonth.month, 1);

    final yearDifference = firstDayOfTargetMonth.year - startingMonth.year;

    return (firstDayOfTargetMonth.month - startingMonth.month) +
        DateTime.monthsPerYear * yearDifference;
  }

  double estimateWhatIfISpend(
      {required int amount,
      required DateTime startingFrom,
      required DateTime until,
      required Projections projectFor}) {
    late DateTime targetMonth;
    switch (projectFor) {
      case Projections.oneMonth:
        targetMonth = budgetDetails.startingMonth;
        break;
      case Projections.threeMonths:
        targetMonth = budgetDetails.startingMonth
            .copyWith(month: budgetDetails.startingMonth.month + 2);
        break;
      case Projections.sixMonths:
        targetMonth = budgetDetails.startingMonth
            .copyWith(month: budgetDetails.startingMonth.month + 5);
        break;
      case Projections.oneYear:
        targetMonth = budgetDetails.startingMonth
            .copyWith(month: budgetDetails.startingMonth.month + 11);
        break;
    }

    var numberOfMonthsApplicable = _numberOfMonthsBetweenInclusiveEnds(
            startingFrom,
            DateTime.fromMillisecondsSinceEpoch(min(
                until.millisecondsSinceEpoch,
                targetMonth.millisecondsSinceEpoch))) -
        _numberOfMonthsBetweenOneExclusiveEnd(
            budgetDetails.startingMonth, startingFrom);

    var balance = estimateSavingsUpTo(targetMonth);

    return balance - amount * numberOfMonthsApplicable;
  }

  DetailedBudget addDailyExpense(
      {required double amount,
      required DateTime day,
      required String description}) {
    return DetailedBudget.copyFromWith(this, dailyExpenses: [
      ..._dailyExpenses,
      DailyExpense(description: description, amount: amount, day: day)
    ]);
  }

  double getLeftDailyExpenseForRunningDay(DateTime today) {
    final earlierExpenseOfThisMonth = _dailyExpenses
        .where((element) =>
            element.day.month == today.month &&
            element.day.year == today.year &&
            element.day.day < today.day)
        .fold(0.0, (value, element) => value + element.amount);

    final earlierExpenseOfToday = _dailyExpenses
        .where((element) =>
            element.day.day == today.day &&
            element.day.month == today.month &&
            element.day.year == today.year)
        .fold(0.0, (previousValue, element) => previousValue + element.amount);

    final endOfMonth = DateTime(today.year, today.month + 1, 0);
    final diffInDaysToEndOfMonth = endOfMonth.difference(today).inDays + 1;

    return double.parse(
        ((dailyExpenseAllocation.amount - earlierExpenseOfThisMonth) /
                    diffInDaysToEndOfMonth -
                earlierExpenseOfToday)
            .toStringAsFixed(2));
  }

  double getLeftDailyExpenseForRunningWeek(DateTime today) {
    var lastDayOfMonth = DateTime(today.year, today.month + 1, 0);
    var diffInDaysToEndOfMonth = lastDayOfMonth.difference(today).inDays + 1;
    var daysToSunday = (DateTime.sunday - today.weekday + 1);
    return getLeftDailyExpenseForRunningDay(today) *
        min(daysToSunday, diffInDaysToEndOfMonth);
  }

  double getLeftDailyExpenseForRunningMonth(DateTime today) {
    final allExpensesOfCurrentMonth = _dailyExpenses
        .where((element) =>
            element.day.month == today.month && element.day.year == today.year)
        .fold(0.0, (value, element) => value + element.amount);
    return dailyExpenseAllocation.amount - allExpensesOfCurrentMonth;
  }
}

class SetupBudgetDetails extends BudgetManagerBlocEvent {
  final double startingAmount;

  SetupBudgetDetails({required this.startingAmount});
}

class AddPeriodIncome extends BudgetManagerBlocEvent {
  final double amount;

  final String description;

  AddPeriodIncome({required this.amount, required this.description});
}

class AddPeriodExpense extends BudgetManagerBlocEvent {
  final double amount;
  final DateTime? applyUntil;
  final DateTime? startingFrom;

  final String description;

  AddPeriodExpense(
      {required this.amount,
      required this.description,
      this.applyUntil,
      this.startingFrom});
}
