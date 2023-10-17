import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'fakes/mock_budget_repository.dart';
import 'fakes/mock_datetime_service.dart';

void main() {
  MockBudgetRepository budgetRepository = MockBudgetRepository();
  MockDateTimeService dateTimeService = MockDateTimeService();
  late BudgetManagerBloc budgetBloc;

  setUp(() {
    budgetBloc = BudgetManagerBloc(budgetRepository, dateTimeService);
  });

  test('Initial state - Uninitialized', () {
    expect(budgetBloc.state, isA<UninitializedBudget>());
  });

  blocTest(
    "Load Initial State when first use",
    build: () => budgetBloc,
    setUp: () {
      when(() => budgetRepository.getBudgetDetails()).thenAnswer(
          (invocation) => Future.value(Left(CannotFindBudgetDetails())));
    },
    act: (bloc) => bloc.add(InitializeBudget()),
    expect: () => [isA<InitializingBudget>(), isA<EmptyBudget>()],
  );

  blocTest(
    "Load Initial State when budget details exist",
    build: () => budgetBloc,
    setUp: () {
      when(() => budgetRepository.getBudgetDetails()).thenAnswer((invocation) =>
          Future.value(Right(BudgetDetails(
              startingAmount: 500,
              startingMonth: DateTime.parse("2023-03-01")))));

      when(() => budgetRepository.getPeriodIncomes())
          .thenAnswer((invocation) => Future.value([]));

      when(() => budgetRepository.getPeriodExpenses())
          .thenAnswer((invocation) => Future.value([]));

      when(() => budgetRepository.getDailyExpenseAllocation())
          .thenAnswer((invocation) => Future.value(null));

      when(() => budgetRepository.getDailyExpenses()).thenAnswer((invocation) {
        return Future.value([]);
      });
    },
    act: (bloc) => bloc.add(InitializeBudget()),
    expect: () => [
      isA<InitializingBudget>(),
      DetailedBudget(
          budgetDetails: BudgetDetails(
              startingAmount: 500, startingMonth: DateTime.parse("2023-03-01")))
    ],
  );

  blocTest(
    "Load Initial State when all state elements exist",
    build: () => budgetBloc,
    setUp: () {
      when(() => budgetRepository.getBudgetDetails()).thenAnswer((invocation) =>
          Future.value(Right(BudgetDetails(
              startingAmount: 500,
              startingMonth: DateTime.parse("2023-03-01")))));

      when(() => budgetRepository.getPeriodIncomes())
          .thenAnswer((invocation) => Future.value([
                PeriodIncome(
                    amount: 200,
                    description: "Some salary",
                    startingFrom: DateTime.parse("2023-03-01")),
                PeriodIncome(
                    amount: 1000,
                    description: "Some retirement",
                    startingFrom: DateTime.parse("2023-03-01"))
              ]));

      when(() => budgetRepository.getPeriodExpenses())
          .thenAnswer((invocation) => Future.value([
                PeriodExpense(
                    amount: 100,
                    startingFrom: DateTime.parse("2023-01-06"),
                    description: "Netflix Subscription"),
                PeriodExpense(
                    amount: 500,
                    startingFrom: DateTime.parse("2023-01-10"),
                    description: "Health insurance",
                    applyUntil: DateTime.parse("2023-06-12"))
              ]));

      when(() => budgetRepository.getDailyExpenseAllocation()).thenAnswer(
          (invocation) =>
              Future.value(DailyExpensePeriodAllocation(amount: 500)));

      when(() => budgetRepository.getDailyExpenses()).thenAnswer((invocation) {
        return Future.value([
          DailyExpense(
              amount: 12,
              day: DateTime.parse("2023-01-03"),
              description: "Pizza"),
          DailyExpense(
              amount: 25,
              day: DateTime.parse("2023-06-10"),
              description: "Burger")
        ]);
      });
    },
    act: (bloc) => bloc.add(InitializeBudget()),
    expect: () => [
      isA<InitializingBudget>(),
      DetailedBudget(
        budgetDetails: BudgetDetails(
          startingAmount: 500,
          startingMonth: DateTime.parse("2023-03-01"),
        ),
        dailyExpenses: [
          DailyExpense(
              amount: 12,
              day: DateTime.parse("2023-01-03"),
              description: "Pizza"),
          DailyExpense(
              amount: 25,
              day: DateTime.parse("2023-06-10"),
              description: "Burger")
        ],
        expenses: [
          PeriodExpense(
              amount: 100,
              startingFrom: DateTime.parse("2023-01-06"),
              description: "Netflix Subscription"),
          PeriodExpense(
              amount: 500,
              startingFrom: DateTime.parse("2023-01-10"),
              description: "Health insurance",
              applyUntil: DateTime.parse("2023-06-12"))
        ],
        incomes: [
          PeriodIncome(
              amount: 200,
              description: "Some salary",
              startingFrom: DateTime.parse("2023-03-01")),
          PeriodIncome(
              amount: 1000,
              description: "Some retirement",
              startingFrom: DateTime.parse("2023-03-01"))
        ],
        dailyExpenseAllocation: DailyExpensePeriodAllocation(amount: 500),
      )
    ],
  );
}
