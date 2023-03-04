
import 'package:bloc_test/bloc_test.dart';
import 'package:core/src/blocs/budget_bloc.dart';
import 'package:core/src/entities/budget_details.dart';
import 'package:core/src/entities/period_expense.dart';
import 'package:core/src/repository/budget_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'fakes/mock_budget_repository.dart';
import 'fakes/mock_datetime_service.dart';

void main() {

  late BudgetManagerBloc budgetBloc; 
  final MockDateTimeService dateTimeService = MockDateTimeService();
  final BudgetRepository budgetRepository = MockBudgetRepository();


  final DateTime actualStartMonth = DateTime.parse("2023-03-01");
  final BudgetDetails actualBudgetDetails = BudgetDetails(startingAmount: 500, startingMonth: actualStartMonth);

  setUp(() {
      registerFallbackValue(PeriodExpense(startingFrom: DateTime.now(), amount: 0));
      budgetBloc = BudgetManagerBloc(budgetRepository, dateTimeService);
    });



  final DateTime currentMonth = DateTime.parse("2023-05-01");
  blocTest<BudgetManagerBloc, BudgetManagerBlocState>('Adding interminable expense',
      build: () => budgetBloc, 
      setUp: () {
          when(() => budgetRepository.addPeriodExpense(any(that: isA<PeriodExpense>()))).thenAnswer((_) => Future.value());
          when(() => dateTimeService.startOfCurrentMonth).thenReturn(currentMonth);
        },
      seed: () => DetailedBudget(budgetDetails: actualBudgetDetails), 
      act: (bloc) => bloc.add(AddPeriodExpense(amount: 60)),
      expect: () => [
      DetailedBudget(budgetDetails: actualBudgetDetails, isAddingExpense: true), 
      DetailedBudget(
        budgetDetails: actualBudgetDetails,
        isAddingExpense: false,
        expenses: [
          PeriodExpense(amount: 60, startingFrom: currentMonth)
        ])
      ], 
      verify: (_) {
          verify(() => budgetRepository.addPeriodExpense(
                  PeriodExpense(amount: 60, startingFrom: currentMonth))
          ).called(1);
          verifyNoMoreInteractions(budgetRepository);
        }
  ); 

  final DateTime expenseEndDate = DateTime.parse("2023-07-01");
  blocTest<BudgetManagerBloc, BudgetManagerBlocState>('Adding terminable expense',
      build: () => budgetBloc, 
      setUp: () {
          when(() => budgetRepository.addPeriodExpense(any(that: isA<PeriodExpense>()))).thenAnswer((_) => Future.value());
          when(() => dateTimeService.startOfCurrentMonth).thenReturn(currentMonth);
        },
      seed: () => DetailedBudget(budgetDetails: actualBudgetDetails), 
      act: (bloc) => bloc.add(AddPeriodExpense(amount: 60, applyUntil: expenseEndDate)),
      expect: () => [
      DetailedBudget(budgetDetails: actualBudgetDetails, isAddingExpense: true), 
      DetailedBudget(
        budgetDetails: actualBudgetDetails,
        isAddingExpense: false,
        expenses: [
          PeriodExpense(amount: 60, startingFrom: currentMonth, applyUntil: expenseEndDate)
        ])
      ], 
      verify: (_) {
          verify(() => budgetRepository.addPeriodExpense(
                  PeriodExpense(amount: 60, startingFrom: currentMonth, applyUntil: expenseEndDate))
          ).called(1);
          verifyNoMoreInteractions(budgetRepository);
        }
  ); 


  DateTime expenseStartMonth = DateTime.parse("2023-04-01"); 
  blocTest<BudgetManagerBloc, BudgetManagerBlocState>('Adding terminable expense and with a specific start date',
      build: () => budgetBloc, 
      setUp: () {
          when(() => budgetRepository.addPeriodExpense(any(that: isA<PeriodExpense>()))).thenAnswer((_) => Future.value());
        },
      seed: () => DetailedBudget(budgetDetails: actualBudgetDetails), 
      act: (bloc) => bloc.add(AddPeriodExpense(amount: 60, startingFrom: expenseStartMonth, applyUntil: expenseEndDate)),
      expect: () => [
      DetailedBudget(budgetDetails: actualBudgetDetails, isAddingExpense: true), 
      DetailedBudget(
        budgetDetails: actualBudgetDetails,
        isAddingExpense: false,
        expenses: [
          PeriodExpense(amount: 60, startingFrom: expenseStartMonth, applyUntil: expenseEndDate)
        ])
      ], 
      verify: (_) {
          verify(() => budgetRepository.addPeriodExpense(
                  PeriodExpense(amount: 60, startingFrom: expenseStartMonth, applyUntil: expenseEndDate))
          ).called(1);
          verifyNoMoreInteractions(budgetRepository);
        }
  ); 


}
