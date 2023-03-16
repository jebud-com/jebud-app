extension DateTimeExt on DateTime {
  DateTime getFirstOfMonthAtMidnight() {
    return copyWith(
        day: 1, hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0);
  }

  DateTime getSameDayMidnight() {
    return copyWith(
        hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0);
  }
}
