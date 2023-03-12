import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryItem {
  final String description;
  final double amount;

  SummaryItem({required this.description, required this.amount});
}

class SummaryList extends StatelessWidget {
  final NumberFormat currencyFormatter;
  final String title;
  final List<SummaryItem> items;

  const SummaryList(
      {super.key,
      required this.currencyFormatter,
      required this.title,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(title),
            children: items.isNotEmpty
                ? items
                    .map(
                      (e) => ListTile(
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Text(e.description),
                            Text(currencyFormatter.format(e.amount))
                          ])),
                    )
                    .toList()
                : [
                    const ListTile(
                        title: Text(
                      "Nothing to list yet.",
                      textAlign: TextAlign.center,
                    ))
                  ],
          ),
        ));
  }
}
