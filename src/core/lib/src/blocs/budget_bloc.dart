import 'package:bloc/bloc.dart';
import 'package:core/src/entities/budget_period.dart';
import 'package:core/src/repository/budget_repository.dart';
import 'package:equatable/equatable.dart';

import '../entities/period_income.dart';

class BudgetManagerBlocState {}

class BudgetManagerBlocEvent {}

class BudgetManagerBloc
    extends Bloc<BudgetManagerBlocEvent, BudgetManagerBlocState> {
  final BudgetRepository _budgetRepository;

  BudgetManagerBloc(this._budgetRepository) : super(UninitializedBudget()) {
    on<AddBudgetPeriod>(_addAddBudgetPeriod);
    on<AddPeriodIncome>(_addPeriodIncome);
  }

  void _addAddBudgetPeriod(AddBudgetPeriod event, Emitter emit) async {
    emit(InitializingBudget());
    final period = BudgetPeriod(end: event.end, start: event.start);
    await _budgetRepository.saveBudgetPeriod(period);
    emit(DetailedBudget(period: period));
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
  final BudgetPeriod period;
  late final List<PeriodIncome> incomes;
  late final bool isAddingIncome;
  DetailedBudget(
      {required this.period,
      List<PeriodIncome>? incomes,
      this.isAddingIncome = false}) {
    this.incomes = incomes ?? [];
  }

  factory DetailedBudget.copyFromWith(DetailedBudget oldDetailedBudget,
          {BudgetPeriod? period,
          List<PeriodIncome>? incomes,
          bool? isAddingIncome}) =>
      DetailedBudget(
          incomes: incomes ?? oldDetailedBudget.incomes,
          period: period ?? oldDetailedBudget.period,
          isAddingIncome: isAddingIncome ?? oldDetailedBudget.isAddingIncome);

  DetailedBudget copyWith(
          {BudgetPeriod? period, List<PeriodIncome>? incomes}) =>
      DetailedBudget(
          period: period ?? this.period, incomes: incomes ?? this.incomes);

  @override
  List<Object?> get props => [period, incomes, isAddingIncome];
}

class AddBudgetPeriod extends BudgetManagerBlocEvent {
  final DateTime start;
  final DateTime end;
  AddBudgetPeriod({required this.start, required this.end});
}

class AddPeriodIncome extends BudgetManagerBlocEvent {
  final double amount;
  AddPeriodIncome({required this.amount});
}
