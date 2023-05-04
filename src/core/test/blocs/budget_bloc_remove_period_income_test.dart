import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/src/blocs/budget_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'fakes/mock_budget_repository.dart';
import 'fakes/mock_datetime_service.dart';

void main() {
  late MockBudgetRepository budgetRepository;
  late MockDateTimeService dateTimeService;
  late BudgetManagerBloc budgetBloc;

  setUp(() {
    budgetRepository = MockBudgetRepository();
    dateTimeService = MockDateTimeService();
    registerFallbackValue(
        PeriodIncome(amount: 0, description: "", startingFrom: DateTime.now()));
    when(() =>
            budgetRepository.permanentlyDeletePeriodIncome(any<PeriodIncome>()))
        .thenAnswer((invocation) => Future.value());
    when(() => budgetRepository.updatePeriodIncome(any<PeriodIncome>()))
        .thenAnswer((invocation) => Future.value());
    budgetBloc = BudgetManagerBloc(budgetRepository, dateTimeService);
  });

  final PeriodIncome incomeToDelete = PeriodIncome(
      amount: 19.99,
      description: "Netflix",
      startingFrom: DateTime.parse("2023-04-01"));

  final PeriodIncome incomeToKeep = PeriodIncome(
      amount: 19.99,
      description: "Monoprix",
      startingFrom: DateTime.parse("2023-04-01"));

  actualDetailedBudgetGetter(
          {required List<PeriodIncome> incomes,
          required bool permanentlyDeletingPeriodIncome,
          required bool stoppingPeriodIncome}) =>
      DetailedBudget(
          budgetDetails: BudgetDetails(
              startingAmount: 600, startingMonth: DateTime.parse("2023-04-01")),
          isPermanentlyDeletingPeriodIncome: permanentlyDeletingPeriodIncome,
          isStoppingPeriodIncome: stoppingPeriodIncome,
          incomes: incomes);

  group("Given Budget with 1 period income", () {
    blocTest<BudgetManagerBloc, BudgetManagerBlocState>(
        "When permanently deleting a period income, then period income should be deleted",
        build: () => budgetBloc,
        seed: () => actualDetailedBudgetGetter(
            incomes: [incomeToDelete],
            permanentlyDeletingPeriodIncome: false,
            stoppingPeriodIncome: false),
        act: (bloc) => bloc.add(PermanentlyDeletePeriodIncome(incomeToDelete)),
        expect: () => [
              actualDetailedBudgetGetter(
                  incomes: [incomeToDelete],
                  permanentlyDeletingPeriodIncome: true,
                  stoppingPeriodIncome: false),
              actualDetailedBudgetGetter(
                  incomes: [],
                  permanentlyDeletingPeriodIncome: false,
                  stoppingPeriodIncome: false)
            ],
        verify: (bloc) {
          verify(() => budgetRepository
              .permanentlyDeletePeriodIncome(incomeToDelete)).called(1);
          verifyNoMoreInteractions(budgetRepository);
        });
  });

  group("Given budget with multiple incomes", () {
    blocTest<BudgetManagerBloc, BudgetManagerBlocState>(
        "When permanently deleting a period income, then period income should be deleted and others should be kept",
        build: () => budgetBloc,
        seed: () => actualDetailedBudgetGetter(
            incomes: [incomeToDelete, incomeToKeep],
            permanentlyDeletingPeriodIncome: false,
            stoppingPeriodIncome: false),
        act: (bloc) => bloc.add(PermanentlyDeletePeriodIncome(incomeToDelete)),
        expect: () => [
              actualDetailedBudgetGetter(
                  incomes: [incomeToDelete, incomeToKeep],
                  permanentlyDeletingPeriodIncome: true,
                  stoppingPeriodIncome: false),
              actualDetailedBudgetGetter(
                  incomes: [incomeToKeep],
                  permanentlyDeletingPeriodIncome: false,
                  stoppingPeriodIncome: false)
            ],
        verify: (bloc) {
          verify(() => budgetRepository
              .permanentlyDeletePeriodIncome(incomeToDelete)).called(1);
          verifyNoMoreInteractions(budgetRepository);
        });
  });

  final PeriodIncome incomeToStop = PeriodIncome(
      amount: 500,
      description: "Life insurance",
      startingFrom: DateTime.parse("2023-04-01"));
  final DateTime stoppingDate = DateTime.parse("2023-10-01");
  final PeriodIncome stoppedIncome = PeriodIncome(
      amount: 500,
      description: "Life insurance",
      startingFrom: DateTime.parse("2023-04-01"),
      applyUntil: stoppingDate);
  blocTest<BudgetManagerBloc, BudgetManagerBlocState>(
      "When having multiple period income, When stopping a period income at a specific month, then it should be applied until that month",
      build: () => budgetBloc,
      seed: () => actualDetailedBudgetGetter(
          incomes: [incomeToStop, incomeToKeep],
          permanentlyDeletingPeriodIncome: false,
          stoppingPeriodIncome: false),
      act: (bloc) => bloc.add(StopPeriodIncome(incomeToStop, at: stoppingDate)),
      expect: () => [
            actualDetailedBudgetGetter(
                incomes: [incomeToStop, incomeToKeep],
                permanentlyDeletingPeriodIncome: false,
                stoppingPeriodIncome: true),
            actualDetailedBudgetGetter(
                incomes: [stoppedIncome, incomeToKeep],
                permanentlyDeletingPeriodIncome: false,
                stoppingPeriodIncome: false)
          ],
      verify: (bloc) {
        verify(() => budgetRepository.updatePeriodIncome(stoppedIncome))
            .called(1);
        verifyNoMoreInteractions(budgetRepository);
      });
}
