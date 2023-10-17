import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddBudgetElement extends StatefulWidget {
  const AddBudgetElement({super.key});

  @override
  State<StatefulWidget> createState() => _AddBudgetElementState();
}

class _AddBudgetElementState extends State<AddBudgetElement>
    with TickerProviderStateMixin {
  Set<int> selectedType = {0};

  late final TabController _incomeExpenseTabController;

  @override
  void initState() {
    _incomeExpenseTabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: BlocProvider.of<BudgetManagerBloc>(context),
        listener: (_, state) {
          state as DetailedBudget;
          if (!state.isAddingDailyExpense &&
              !state.isAddingExpense &&
              !state.isAddingIncome) Navigator.pop(context);
        },
        child: SizedBox(
            height: 390 + 60 + 16 + 56 + 80,
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                    child: AnimatedContainer(
                        height: 390 + 60 + 16 + 56 + 80,
                        duration: const Duration(microseconds: 300),
                        padding: const EdgeInsets.only(
                          top: 24,
                          right: 16,
                          left: 16,
                        ),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SegmentedButton(
                                showSelectedIcon: false,
                                segments: const [
                                  ButtonSegment(
                                      value: 0,
                                      label: Text("Expense"),
                                      icon: Icon(Icons.money_off)),
                                  ButtonSegment(
                                      value: 1,
                                      label: Text("Income"),
                                      icon: Icon(Icons.attach_money)),
                                ],
                                selected: selectedType,
                                onSelectionChanged: (newValue) => setState(() {
                                  selectedType = newValue;
                                  _incomeExpenseTabController
                                      .animateTo(newValue.first);
                                }),
                              ),
                              const SizedBox.square(dimension: 24),
                              Flexible(
                                  child: TabBarView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      controller: _incomeExpenseTabController,
                                      children: const [
                                    AddExpense(),
                                    AddIncome()
                                  ]))
                            ]))))));
  }
}

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<StatefulWidget> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> with TickerProviderStateMixin {
  final TextEditingController _startDateTextController =
      TextEditingController();
  final TextEditingController _endDateTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();

  late TabController _dailyPeriodicallyTabController;

  Set<int> selectedType = {0};
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool hasEndDate = false;

  bool get _isAddingDailyExpense => selectedType.first == 0;

  bool get _isAddingPeriodExpense => selectedType.first == 1;

  bool get canConfirm {
    return _amountTextController.text.trim().isNotEmpty &&
        _descriptionTextController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    _startDateTextController.text = DateFormat.yMMMEd().format(startDate);
    _endDateTextController.text = DateFormat.yMMMEd().format(endDate);
    _dailyPeriodicallyTabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SegmentedButton(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(
              value: 0, label: Text("Today"), icon: Icon(Icons.today)),
          ButtonSegment(
              value: 1,
              label: Text("Periodically"),
              icon: Icon(Icons.event_repeat_rounded)),
        ],
        selected: selectedType,
        onSelectionChanged: (newValue) => setState(() {
          selectedType = newValue;
          _dailyPeriodicallyTabController.animateTo(newValue.first);
        }),
      ),
      const SizedBox.square(
        dimension: 24,
      ),
      if (_isAddingPeriodExpense) ...[
        GestureDetector(
            onTap: () async {
              var selectedStartDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                  initialDate: DateTime.now(),
                  lastDate: DateTime(275760, 09, 13));
              if (selectedStartDate != null) {
                setState(() {
                  startDate = selectedStartDate;
                  _startDateTextController.text =
                      DateFormat.yMMMEd().format(startDate);
                  if (startDate.isAfter(endDate)) {
                    endDate = startDate;
                    _endDateTextController.text =
                        DateFormat.yMMMEd().format(endDate);
                  }
                });
              }
            },
            child: TextFormField(
                enabled: false,
                controller: _startDateTextController,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text("Start date"),
                  disabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                ))),
        const SizedBox.square(
          dimension: 8,
        ),
        Flexible(
            child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Has an end date"),
                value: hasEndDate,
                onChanged: (newValue) {
                  setState(() {
                    hasEndDate = newValue!;
                  });
                })),
        const SizedBox.square(
          dimension: 8,
        ),
        if (hasEndDate) ...[
          GestureDetector(
              onTap: () async {
                var selectedEndDate = await showDatePicker(
                    context: context,
                    firstDate: startDate,
                    initialDate: endDate,
                    lastDate: DateTime(275760, 09, 13));
                if (selectedEndDate != null) {
                  setState(() {
                    endDate = selectedEndDate;
                    _endDateTextController.text =
                        DateFormat.yMMMEd().format(endDate);
                  });
                }
              },
              child: TextFormField(
                  enabled: false,
                  controller: _endDateTextController,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text("End date"),
                    disabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                  ))),
          const SizedBox.square(
            dimension: 16,
          ),
        ]
      ],
      TextFormField(
          controller: _amountTextController,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          keyboardType: const TextInputType.numberWithOptions(
              signed: false, decimal: true),
          decoration: const InputDecoration(
              label: Text("Amount"),
              border: OutlineInputBorder(),
              suffix: Text("€"))),
      const SizedBox.square(
        dimension: 24,
      ),
      TextFormField(
          controller: _descriptionTextController,
          textInputAction: TextInputAction.go,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            label: Text("Description"),
            border: OutlineInputBorder(),
          )),
      const SizedBox.square(
        dimension: 16,
      ),
      OutlinedButton.icon(
          onPressed: _addExpense,
          label: const Text("Confirm"),
          icon: const Icon(Icons.check))
    ]);
  }

  void _addExpense() {
    if (!canConfirm) return;
    if (_isAddingDailyExpense) {
      BlocProvider.of<BudgetManagerBloc>(context).add(AddDailyExpense(
          amount: double.parse(_amountTextController.text.trim()),
          description: _descriptionTextController.text.trim()));
    } else if (_isAddingPeriodExpense) {
      BlocProvider.of<BudgetManagerBloc>(context).add(AddPeriodExpense(
          amount: double.parse(_amountTextController.text.trim()),
          startingFrom: startDate,
          applyUntil: hasEndDate ? endDate : null,
          description: _descriptionTextController.text.trim()));
    }
  }
}

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<StatefulWidget> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> with TickerProviderStateMixin {
  final TextEditingController _startDateTextController =
      TextEditingController();
  final TextEditingController _endDateTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();

  Set<int> selectedType = {0};
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool hasEndDate = false;

  bool get canConfirm {
    return _amountTextController.text.trim().isNotEmpty &&
        _descriptionTextController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    _startDateTextController.text = DateFormat.yMMMEd().format(startDate);
    _endDateTextController.text = DateFormat.yMMMEd().format(endDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox.square(
        dimension: 24,
      ),
      GestureDetector(
          onTap: () async {
            var selectedStartDate = await showDatePicker(
                context: context,
                firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                initialDate: DateTime.now(),
                lastDate: DateTime(275760, 09, 13));
            if (selectedStartDate != null) {
              setState(() {
                startDate = selectedStartDate;
                _startDateTextController.text =
                    DateFormat.yMMMEd().format(startDate);
                if (startDate.isAfter(endDate)) {
                  endDate = startDate;
                  _endDateTextController.text =
                      DateFormat.yMMMEd().format(endDate);
                }
              });
            }
          },
          child: TextFormField(
              enabled: false,
              controller: _startDateTextController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                label: Text("Start date"),
                disabledBorder: OutlineInputBorder(),
                border: OutlineInputBorder(),
              ))),
      const SizedBox.square(
        dimension: 8,
      ),
      Flexible(
          child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text("Has an end date"),
              value: hasEndDate,
              onChanged: (newValue) {
                setState(() {
                  hasEndDate = newValue!;
                });
              })),
      const SizedBox.square(
        dimension: 8,
      ),
      if (hasEndDate) ...[
        GestureDetector(
            onTap: () async {
              var selectedEndDate = await showDatePicker(
                  context: context,
                  firstDate: startDate,
                  initialDate: endDate,
                  lastDate: DateTime(275760, 09, 13));
              if (selectedEndDate != null) {
                setState(() {
                  endDate = selectedEndDate;
                  _endDateTextController.text =
                      DateFormat.yMMMEd().format(endDate);
                });
              }
            },
            child: TextFormField(
                enabled: false,
                controller: _endDateTextController,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text("End date"),
                  disabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                ))),
        const SizedBox.square(
          dimension: 16,
        ),
      ],
      TextFormField(
          controller: _amountTextController,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          keyboardType: const TextInputType.numberWithOptions(
              signed: false, decimal: true),
          decoration: const InputDecoration(
              label: Text("Amount"),
              border: OutlineInputBorder(),
              suffix: Text("€"))),
      const SizedBox.square(
        dimension: 24,
      ),
      TextFormField(
          controller: _descriptionTextController,
          textInputAction: TextInputAction.go,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            label: Text("Description"),
            border: OutlineInputBorder(),
          )),
      const SizedBox.square(
        dimension: 16,
      ),
      OutlinedButton.icon(
          onPressed: _addIncome,
          label: const Text("Confirm"),
          icon: const Icon(Icons.check))
    ]);
  }

  void _addIncome() {
    if (!canConfirm) return;

    BlocProvider.of<BudgetManagerBloc>(context).add(AddPeriodIncome(
        startingFrom: startDate,
        applyUntil: hasEndDate ? endDate : null,
        amount: double.parse(_amountTextController.text.trim()),
        description: _descriptionTextController.text.trim()));
  }
}
