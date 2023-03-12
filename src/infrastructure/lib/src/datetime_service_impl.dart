import 'package:core/core.dart';

class DateTimeServiceImpl extends DateTimeService {
  @override
  DateTime get startOfCurrentMonth => DateTime.now().copyWith(day: 1);

  @override
  DateTime get today => DateTime.now();
}
