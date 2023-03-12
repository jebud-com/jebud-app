import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetText extends Text {
  final NumberFormat nbrFormatter;

  BudgetText(
      {super.key,
      required this.nbrFormatter,
      required double budget,
      required double fontSize})
      : super(nbrFormatter.format(budget),
            style: TextStyle(
                fontSize: fontSize,
                color: budget >= 0 && budget < 500
                    ? Colors.orange
                    : budget > 500
                        ? Colors.green
                        : Colors.red,
                fontWeight: FontWeight.w700));
}
