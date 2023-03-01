import 'package:bloc/bloc.dart';
import 'package:core/src/entities/budget_period.dart';
import 'package:core/src/repository/budget_repository.dart';
import 'package:collection/collection.dart';
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
    final period = BudgetPeriod(end: event.end, start: event.start);
    await _budgetRepository.saveBudgetPeriod(period);
    emit(DetailedBudget(period: period));
  }

  void _addPeriodIncome(AddPeriodIncome event, Emitter emit) async {
    final income = PeriodIncome(amount: event.amount);
    final currentDetailedBudtet = (state as DetailedBudget);
    final newBudgetDetails = currentDetailedBudtet.copyWith(incomes: [...currentDetailedBudtet.incomes, income]);
    await _budgetRepository.addPeriodIncome(income);
    emit(newBudgetDetails);
    }
}

class UninitializedBudget extends BudgetManagerBlocState {}

class DetailedBudget extends Equatable implements BudgetManagerBlocState {
  final BudgetPeriod period;
  late final List<PeriodIncome> incomes;
    DetailedBudget({required this.period, List<PeriodIncome>? incomes}) {
      this.incomes = incomes ?? [];
    }

  DetailedBudget copyWith({
    BudgetPeriod? period,
    List<PeriodIncome>? incomes
  }) => DetailedBudget(
    period: period ?? this.period,
    incomes: incomes ?? this.incomes
  );

  @override
  List<Object?> get props => [
    period, incomes
  ] ;

}

class AddBudgetPeriod extends BudgetManagerBlocEvent {
  final DateTime start;
  final DateTime end;
  AddBudgetPeriod({required this.start, required this.end});
}


class AddPeriodIncome extends BudgetManagerBlocEvent {
  final double amount;
  AddPeriodIncome({ required this.amount});
}

