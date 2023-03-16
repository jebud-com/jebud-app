import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetText extends Text {
  final NumberFormat nbrFormatter;

  BudgetText(
      {super.key,
      required double orangeBoundary,
      required this.nbrFormatter,
      required double budget,
      required double fontSize})
      : super(nbrFormatter.format(budget),
            style: TextStyle(
                fontSize: fontSize,
                color: budget >= 0 && budget < orangeBoundary
                    ? Colors.orange
                    : budget > orangeBoundary
                        ? Colors.green
                        : Colors.red,
                fontWeight: FontWeight.w700));
}
