@Timeout(Duration(seconds: 10))
import 'package:bloc_test/bloc_test.dart';
import 'package:core/src/blocs/budget_bloc.dart';
import 'package:core/src/entities/budget_details.dart';
import 'package:core/src/entities/period_income.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'fakes/mock_budget_repository.dart';
import 'fakes/mock_datetime_service.dart';

void main() {
  late BudgetManagerBloc budgetBloc;
  late MockBudgetRepository budgetRepository;
  MockDateTimeService dateTimeService = MockDateTimeService();

  final PeriodIncome existingPeriodIncome =
      PeriodIncome(amount: 2400, description: 'Salary');
  final BudgetDetails existingBudgetDetails =
      BudgetDetails(startingAmount: 500, startingMonth: DateTime.now());

  setUp(() {
    registerFallbackValue(PeriodIncome(amount: 0, description: ''));
    budgetRepository = MockBudgetRepository();
    budgetBloc = BudgetManagerBloc(budgetRepository, dateTimeService);
  });


  blocTest<BudgetManagerBloc, BudgetManagerBlocState>(
      'Add first budget period income',
      build: () => budgetBloc,
      seed: () => DetailedBudget(budgetDetails: existingBudgetDetails),
      setUp: () {
        when(() => budgetRepository.addPeriodIncome(
            any(that: isA<PeriodIncome>()))).thenAnswer((_) => Future.value());
      },
      act: (bloc) =>
          bloc.add(AddPeriodIncome(amount: 2400, description: 'salary')),
      expect: () => [
            DetailedBudget(
                budgetDetails: existingBudgetDetails,
                incomes: [],
                isAddingIncome: true),
            DetailedBudget(
                budgetDetails: existingBudgetDetails,
                incomes: [PeriodIncome(amount: 2400, description: 'salary')],
                isAddingIncome: false)
          ],
      verify: (_) {
        verify(() => budgetRepository.addPeriodIncome(
            PeriodIncome(amount: 2400, description: 'salary'))).called(1);
        verifyNoMoreInteractions(budgetRepository);
      });

  PeriodIncome expectedPeriodIncome =
      PeriodIncome(amount: 600, description: 'something else');
  blocTest<BudgetManagerBloc, BudgetManagerBlocState>(
      'Add second budget period income',
      build: () => budgetBloc,
      seed: () => DetailedBudget(
          budgetDetails: existingBudgetDetails,
          incomes: [existingPeriodIncome]),
      setUp: () {
        when(() => budgetRepository.addPeriodIncome(
            any(that: isA<PeriodIncome>()))).thenAnswer((_) => Future.value());
      },
      act: (bloc) =>
          bloc.add(AddPeriodIncome(amount: 600, description: 'something else')),
      expect: () => [
            DetailedBudget(
                budgetDetails: existingBudgetDetails,
                incomes: [existingPeriodIncome],
                isAddingIncome: true),
            DetailedBudget(
                budgetDetails: existingBudgetDetails,
                incomes: [existingPeriodIncome, expectedPeriodIncome],
                isAddingIncome: false)
          ],
      verify: (_) {
        verify(() => budgetRepository.addPeriodIncome(
                PeriodIncome(amount: 600, description: 'something else')))
            .called(1);
        verifyNoMoreInteractions(budgetRepository);
      });
}
