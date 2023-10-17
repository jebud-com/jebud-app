import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryItem {
  final String description;
  final double amount;

  SummaryItem({required this.description, required this.amount});
}

class SummaryList<T> extends StatelessWidget {
  final NumberFormat currencyFormatter;
  final String title;
  final List<T> items;
  final SummaryItem Function(T value) toSummaryTile;
  final Future<bool> Function(T value)? onDelete;
  final Future<bool> Function(T value)? onStop;

  const SummaryList(
      {super.key,
      this.onDelete,
      this.onStop,
      required this.currencyFormatter,
      required this.title,
      required this.items,
      required this.toSummaryTile});

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
                      (e) => Dismissible(
                          confirmDismiss: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              return onDelete!(e);
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              return onStop!(e);
                            }
                            return Future.value(false);
                          },
                          direction: (onDelete != null && onStop != null)
                              ? DismissDirection.horizontal
                              : onDelete != null
                                  ? DismissDirection.startToEnd
                                  : onStop != null
                                      ? DismissDirection.endToStart
                                      : DismissDirection.none,
                          background: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (onDelete != null)
                                  Expanded(
                                      child: Container(
                                    color: Colors.red,
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 12),
                                          child: Icon(
                                              Icons.delete_forever_outlined,
                                              color: Colors.white)),
                                    ),
                                  )),
                              ]),
                          secondaryBackground: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (onStop != null)
                                  Expanded(
                                      child: Container(
                                          color: Colors.orange,
                                          child: const Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 12),
                                                child: Icon(Icons.edit_calendar,
                                                    color: Colors.white)),
                                          )))
                              ]),
                          key: ValueKey(e.hashCode),
                          child: ListTile(
                              title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                Text(toSummaryTile(e).description),
                                Text(currencyFormatter
                                    .format(toSummaryTile(e).amount))
                              ]))),
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
