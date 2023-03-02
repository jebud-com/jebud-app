import 'package:bloc/bloc.dart';
import 'package:core/src/entities/budget_details.dart';
import 'package:core/src/interfaces/date_time_service.dart';
import 'package:core/src/repository/budget_repository.dart';
import 'package:equatable/equatable.dart';

import '../entities/period_income.dart';

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

    final income = PeriodIncome(amount: event.amount);
    await _budgetRepository.addPeriodIncome(income);

    final currentDetailedBudtet = (state as DetailedBudget);
    emit(DetailedBudget.copyFromWith(state as DetailedBudget,
        isAddingIncome: false,
        incomes: [...currentDetailedBudtet.incomes, income]));
  }
}

class UninitializedBudget extends BudgetManagerBlocState {}

class InitializingBudget extends BudgetManagerBlocState {}

class DetailedBudget extends Equatable implements BudgetManagerBlocState {
  final BudgetDetails budgetDetails;
  late final List<PeriodIncome> incomes;
  late final bool isAddingIncome;
  DetailedBudget(
      {required this.budgetDetails,
      List<PeriodIncome>? incomes,
      this.isAddingIncome = false}) {
    this.incomes = incomes ?? [];
  }

  factory DetailedBudget.copyFromWith(DetailedBudget oldDetailedBudget,
          {List<PeriodIncome>? incomes, bool? isAddingIncome}) =>
      DetailedBudget(
          budgetDetails: oldDetailedBudget.budgetDetails,
          incomes: incomes ?? oldDetailedBudget.incomes,
          isAddingIncome: isAddingIncome ?? oldDetailedBudget.isAddingIncome);

  @override
  List<Object?> get props => [budgetDetails, incomes, isAddingIncome];

  double estimateSavingsUpTo(DateTime targetMonth) =>
      budgetDetails.startingAmount +
      (incomes.fold(0.0, (value, element) => value + element.amount)) *
          _numberOfMonthsToTargetMonth(targetMonth);

  int _numberOfMonthsToTargetMonth(DateTime targetMonth) {
    final startingMonth = budgetDetails.startingMonth;
    final firstDayOfTargetMonth =
        DateTime(targetMonth.year, targetMonth.month, 1);

    final yearDifference = firstDayOfTargetMonth.year - startingMonth.year;

    return (firstDayOfTargetMonth.month - startingMonth.month) +
        12 * yearDifference +
        1;
  }
}

class SetupBudgetDetails extends BudgetManagerBlocEvent {
  final double startingAmount;
  SetupBudgetDetails({required this.startingAmount});
}

class AddPeriodIncome extends BudgetManagerBlocEvent {
  final double amount;
  AddPeriodIncome({required this.amount});
}
