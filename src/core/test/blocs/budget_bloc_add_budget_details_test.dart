import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/src/blocs/budget_bloc.dart';
import 'package:core/src/entities/budget_details.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'fakes/mock_budget_repository.dart';
import 'fakes/mock_datetime_service.dart';

void main() {
  MockBudgetRepository budgetRepository = MockBudgetRepository();
  MockDateTimeService dateTimeService = MockDateTimeService();

  setUpAll(() => registerFallbackValue(
      BudgetDetails(startingMonth: DateTime.now(), startingAmount: 0)));

  DateTime expectedStartingMonth = DateTime.parse("2023-03-01");
  blocTest('When Adding budget details',
      setUp: () {
        when(() => dateTimeService.startOfCurrentMonth)
            .thenReturn(expectedStartingMonth);
        when(() => budgetRepository.saveBudgetDetails(
            any(that: isA<BudgetDetails>()))).thenAnswer((_) => Future.value());
      },
      build: () => BudgetManagerBloc(budgetRepository, dateTimeService),
      act: (bloc) => bloc.add(SetupBudgetDetails(startingAmount: 400)),
      expect: () => [
            isA<InitializingBudget>(),
            DetailedBudget(
                budgetDetails: BudgetDetails(
                    startingAmount: 400, startingMonth: expectedStartingMonth))
          ],
      verify: (_) {
        verify(() => budgetRepository.saveBudgetDetails(BudgetDetails(
            startingAmount: 400,
            startingMonth: expectedStartingMonth))).called(1);
        verifyNoMoreInteractions(budgetRepository);
      });
}
