import 'package:core/core.dart';
import 'package:infrastructure/src/datetime_service_impl.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test("date time service return first day of current month", () {
    DateTimeService dateTimeService = DateTimeServiceImpl();

    var result = dateTimeService.startOfCurrentMonth;

    expect(result, isNotNull);
    expect(result.day, equals(1));
    expect(result.month, equals(DateTime.now().month));
    expect(result.year, equals(DateTime.now().year));
  });

  test("date time service return current day of current month", () {
    DateTimeService dateTimeService = DateTimeServiceImpl();

    var result = dateTimeService.today;

    expect(result, isNotNull);
    expect(result.day, equals(DateTime.now().day));
    expect(result.month, equals(DateTime.now().month));
    expect(result.year, equals(DateTime.now().year));
  });
}
