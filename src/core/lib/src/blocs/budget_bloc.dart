import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:core/src/entities/budget_details.dart';
import 'package:core/src/entities/daily_expense_period_allocation.dart';
import 'package:core/src/entities/period_expense.dart';
import 'package:core/src/interfaces/date_time_service.dart';
import 'package:core/src/repository/budget_repository.dart';
import 'package:core/src/utils/date_time_extensions.dart';
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
    on<InitializeBudget>(_initializeBudget);
    on<SetupBudgetDetails>(_setupBudgetDetails);
    on<AddPeriodIncome>(_addPeriodIncome);
    on<AddPeriodExpense>(_addPeriodExpense);
    on<AddDailyExpenseAllocation>(_addDailyExpenseAllocation);
    on<UpdateDailyExpenseAllocation>(_updateDailyExpenseAllocation);
    on<AddDailyExpense>(_addDailyExpense);
  }

  void _initializeBudget(InitializeBudget event, Emitter emit) async {
    emit(InitializingBudget());
    var result = await _budgetRepository.getBudgetDetails();
    await result.fold<Future>((l) async => emit(EmptyBudget()),
        (r) async => await _buildAndEmitDetailedBudget(r, emit));
  }

  Future _buildAndEmitDetailedBudget(
      BudgetDetails budgetDetails, Emitter emit) async {
    var incomes = await _budgetRepository.getPeriodIncomes();
    var expenses = await _budgetRepository.getPeriodExpenses();
    var dailyExpenses = await _budgetRepository.getDailyExpenses();
    var dailyExpenseAllocation =
        await _budgetRepository.getDailyExpenseAllocation();

    emit(DetailedBudget(
        budgetDetails: budgetDetails,
        incomes: incomes.toList(),
        expenses: expenses.toList(),
        dailyExpenses: dailyExpenses.toList(),
        dailyExpenseAllocation: dailyExpenseAllocation));
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

  void _addDailyExpenseAllocation(AddDailyExpenseAllocation event,
      Emitter<BudgetManagerBlocState> emit) async {
    emit(DetailedBudget.copyFromWith(state as DetailedBudget,
        isAddingDailyExpenseAllocation: true));
    var dailyExpenseAllocation =
        DailyExpensePeriodAllocation(amount: event.amount);
    await _budgetRepository.addDailyExpenseAllocation(dailyExpenseAllocation);
    emit(DetailedBudget.copyFromWith(state as DetailedBudget,
        isAddingDailyExpenseAllocation: false,
        dailyExpenseAllocation: dailyExpenseAllocation));
  }

  void _updateDailyExpenseAllocation(UpdateDailyExpenseAllocation event,
      Emitter<BudgetManagerBlocState> emit) async {
    emit(DetailedBudget.copyFromWith(state as DetailedBudget,
        isAddingDailyExpenseAllocation: true));
    var dailyExpenseAllocation =
        DailyExpensePeriodAllocation(amount: event.amount);
    await _budgetRepository
        .updateDailyExpenseAllocation(dailyExpenseAllocation);
    emit(DetailedBudget.copyFromWith(state as DetailedBudget,
        isAddingDailyExpenseAllocation: false,
        dailyExpenseAllocation: dailyExpenseAllocation));
  }

  void _addDailyExpense(AddDailyExpense event, Emitter emit) async {
    emit(DetailedBudget.copyFromWith(state as DetailedBudget,
        isAddingDailyExpense: true));
    var dailyExpense = DailyExpense(
        amount: event.amount,
        day: _dateTimeService.today,
        description: event.description);
    await _budgetRepository.addDailyExpense(dailyExpense);
    emit(DetailedBudget.copyFromWith(state as DetailedBudget,
        isAddingDailyExpense: false,
        dailyExpenses: [
          ...(state as DetailedBudget).dailyExpenses,
          dailyExpense
        ]));
  }
}

class UninitializedBudget extends BudgetManagerBlocState {}

class InitializingBudget extends BudgetManagerBlocState {}

class EmptyBudget extends BudgetManagerBlocState {}

class DetailedBudget extends Equatable implements BudgetManagerBlocState {
  final BudgetDetails budgetDetails;
  late final List<PeriodIncome> incomes;
  late final List<DailyExpense> dailyExpenses;
  late final List<PeriodExpense> expenses;
  late final DailyExpensePeriodAllocation dailyExpenseAllocation;
  final bool isAddingIncome;
  final bool isAddingExpense;
  final bool isAddingDailyExpense;
  final bool isAddingDailyExpenseAllocation;

  DetailedBudget(
      {required this.budgetDetails,
      List<PeriodIncome>? incomes,
      List<PeriodExpense>? expenses,
      List<DailyExpense>? dailyExpenses,
      this.isAddingIncome = false,
      this.isAddingExpense = false,
      this.isAddingDailyExpense = false,
      this.isAddingDailyExpenseAllocation = false,
      DailyExpensePeriodAllocation? dailyExpenseAllocation}) {
    this.incomes = incomes ?? [];
    this.expenses = expenses ?? [];
    this.dailyExpenses = dailyExpenses ?? [];
    this.dailyExpenseAllocation =
        dailyExpenseAllocation ?? DailyExpensePeriodAllocation.zero();
  }

  factory DetailedBudget.copyFromWith(DetailedBudget oldDetailedBudget,
          {List<PeriodIncome>? incomes,
          List<PeriodExpense>? expenses,
          List<DailyExpense>? dailyExpenses,
          bool? isAddingExpense,
          bool? isAddingIncome,
          bool? isAddingDailyExpense,
          bool? isAddingDailyExpenseAllocation,
          DailyExpensePeriodAllocation? dailyExpenseAllocation}) =>
      DetailedBudget(
          budgetDetails: oldDetailedBudget.budgetDetails,
          incomes: incomes ?? oldDetailedBudget.incomes,
          expenses: expenses ?? oldDetailedBudget.expenses,
          dailyExpenseAllocation: dailyExpenseAllocation ??
              oldDetailedBudget.dailyExpenseAllocation,
          dailyExpenses: dailyExpenses ?? oldDetailedBudget.dailyExpenses,
          isAddingDailyExpenseAllocation: isAddingDailyExpenseAllocation ??
              oldDetailedBudget.isAddingDailyExpenseAllocation,
          isAddingExpense: isAddingExpense ?? oldDetailedBudget.isAddingExpense,
          isAddingDailyExpense:
              isAddingDailyExpense ?? oldDetailedBudget.isAddingDailyExpense,
          isAddingIncome: isAddingIncome ?? oldDetailedBudget.isAddingIncome);

  @override
  List<Object?> get props => [
        budgetDetails,
        incomes,
        dailyExpenses,
        expenses,
        isAddingIncome,
        isAddingExpense,
        isAddingDailyExpense,
        isAddingDailyExpenseAllocation
      ];

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
        dailyExpenses
            .where((element) =>
                element.day.month == targetMonth.month &&
                element.day.year == targetMonth.year)
            .fold(0.0, (value, element) => value + element.amount));

    final allEarlierExpenses = dailyExpenses
        .where((element) =>
            element.day.month < targetMonth.month &&
                element.day.year == targetMonth.year ||
            element.day.year < targetMonth.year)
        .fold(0.0, (value, element) => value + element.amount);

    return result -
        maxBetweenAllocationAndTotalExpensesOfTheMonth -
        allEarlierExpenses;
  }

  double _expensesFor(DateTime month) {
    month = month.getFirstOfMonthAtMidnight();
    return expenses.fold(0.0, (value, element) {
      var applyUntil = element.applyUntil.getFirstOfMonthAtMidnight();
      var startingFrom = element.startingFrom.getFirstOfMonthAtMidnight();
      if (applyUntil.isAtSameMomentAs(month) ||
          startingFrom.isAtSameMomentAs(month) ||
          applyUntil.isAfter(month) && startingFrom.isBefore(month)) {
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

  double getLeftDailyExpenseForRunningDay(DateTime today) {
    final earlierExpenseOfThisMonth = dailyExpenses
        .where((element) =>
            element.day.month == today.month &&
            element.day.year == today.year &&
            element.day.day < today.day)
        .fold(0.0, (value, element) => value + element.amount);

    final earlierExpenseOfToday = dailyExpenses
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
    var startCurrentWeek =
        today.add(Duration(days: DateTime.monday - today.weekday)).copyWith(
              hour: 0,
              minute: 0,
              millisecond: 0,
              second: 0,
              microsecond: 0,
            );
    final isStartOfCurrentWeekWasLastMonth =
        startCurrentWeek.month != today.month;
    if (isStartOfCurrentWeekWasLastMonth) {
      startCurrentWeek = today.getFirstOfMonthAtMidnight();
    }
    var lastDayOfMonth = DateTime(today.year, today.month + 1, 0);
    var diffInDayFromStartOfWeekToEndOfMonth =
        lastDayOfMonth.difference(startCurrentWeek).inDays + 1;
    var daysToSundayFromStartOfWeek =
        (DateTime.sunday - startCurrentWeek.weekday + 1);
    var lastDayOfLastWeek = startCurrentWeek.add(Duration(days: -1));

    final isTodayStartOfMonth =
        startCurrentWeek != today.getFirstOfMonthAtMidnight();

    var expensesOfEarlierWeeksOfCurrentMonth = dailyExpenses
        .where((element) =>
            element.day.month == lastDayOfLastWeek.month &&
            element.day.year == lastDayOfLastWeek.year &&
            element.day.day <= lastDayOfLastWeek.day)
        .fold(0.0, (value, element) => value + element.amount);

    var allRemainingToSpendUpToThisWeek = (dailyExpenseAllocation.amount -
        (isTodayStartOfMonth ? expensesOfEarlierWeeksOfCurrentMonth : 0));

    var allowedToSpendUpToThisWeekPerDay =
        allRemainingToSpendUpToThisWeek / diffInDayFromStartOfWeekToEndOfMonth;

    final allowedToSpendForThisWeek = allowedToSpendUpToThisWeekPerDay *
        min(daysToSundayFromStartOfWeek, diffInDayFromStartOfWeekToEndOfMonth);

    final earlierExpensesOfThisWeek = dailyExpenses
        .where((element) =>
            element.day.year == startCurrentWeek.year &&
                element.day.month == startCurrentWeek.month &&
                element.day.isAfter(startCurrentWeek) ||
            element.day.isAtSameMomentAs(startCurrentWeek))
        .fold(0.0, (value, element) => value + element.amount);

    return double.parse((allowedToSpendForThisWeek - earlierExpensesOfThisWeek)
        .toStringAsFixed(2));
  }

  double getLeftDailyExpenseForRunningMonth(DateTime today) {
    final allExpensesOfCurrentMonth = dailyExpenses
        .where((element) =>
            element.day.month == today.month && element.day.year == today.year)
        .fold(0.0, (value, element) => value + element.amount);
    return dailyExpenseAllocation.amount - allExpensesOfCurrentMonth;
  }

  List<DailyExpense> getDailyExpensesForDay(DateTime day) {
    return dailyExpenses
        .where((element) =>
            element.day.day == day.day &&
            element.day.month == day.month &&
            element.day.year == day.year)
        .toList();
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

class AddDailyExpenseAllocation extends BudgetManagerBlocEvent {
  final double amount;

  AddDailyExpenseAllocation({required this.amount});
}

class UpdateDailyExpenseAllocation extends BudgetManagerBlocEvent {
  final double amount;

  UpdateDailyExpenseAllocation({required this.amount});
}

class AddDailyExpense extends BudgetManagerBlocEvent {
  final double amount;
  final String description;

  AddDailyExpense({required this.amount, required this.description});
}

class InitializeBudget extends BudgetManagerBlocEvent {}
