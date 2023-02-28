import 'package:bloc/bloc.dart';
import 'package:core/src/entities/budget_period.dart';
import 'package:core/src/repository/budget_repository.dart';

class BudgetManagerBlocState {}

class BudgetManagerBlocEvent {}

class BudgetManagerBloc
    extends Bloc<BudgetManagerBlocEvent, BudgetManagerBlocState> {
  final BudgetRepository _budgetRepository;

  BudgetManagerBloc(this._budgetRepository) : super(UninitializedBudget()) {
    on<AddBudgetPeriod>(_addAddBudgetPeriod);
  }

  void _addAddBudgetPeriod(AddBudgetPeriod event, Emitter emit) async {
    final period = BudgetPeriod(end: event.end, start: event.start);
    await _budgetRepository.saveBudgetPeriod(period);
    emit(DetailedBudget(period: period));
  }
}

class UninitializedBudget extends BudgetManagerBlocState {}

class DetailedBudget extends BudgetManagerBlocState {
  final BudgetPeriod period;
  DetailedBudget({required this.period});

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is DetailedBudget && other.period == period;

  @override
  int get hashCode => period.hashCode;
}

class AddBudgetPeriod extends BudgetManagerBlocEvent {
  final DateTime start;
  final DateTime end;
  AddBudgetPeriod({required this.start, required this.end});
}
