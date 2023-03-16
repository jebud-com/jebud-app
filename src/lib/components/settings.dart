import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsWidget();
  }
}

class _SettingsWidget extends State<Settings> {
  final _dailyAllocationTextController = TextEditingController();

  bool get hasChanges {
    return double.tryParse(_dailyAllocationTextController.text.trim()) !=
        (BlocProvider.of<BudgetManagerBloc>(context).state as DetailedBudget)
            .dailyExpenseAllocation
            .amount;
  }

  @override
  void initState() {
    _dailyAllocationTextController.text =
        (BlocProvider.of<BudgetManagerBloc>(context).state as DetailedBudget)
            .dailyExpenseAllocation
            .amount
            .toString();
    _dailyAllocationTextController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        listener: (context, state) {
          state as DetailedBudget;
          if (!state.isAddingDailyExpenseAllocation) {
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() {});
          }
        },
        bloc: BlocProvider.of<BudgetManagerBloc>(context),
        child: Scaffold(
          body: SingleChildScrollView(
              child: Container(
            height: 550,
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox.square(dimension: 16),
                  SvgPicture.asset("assets/svg/illustrations/settings.svg",
                      height: 200),
                  const Text(
                    "You can manage global settings in this page",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox.square(dimension: 16),
                  TextFormField(
                      controller: _dailyAllocationTextController,
                      textInputAction: TextInputAction.go,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      decoration: const InputDecoration(
                          label: Text("Daily Expense Monthly Allocation"),
                          border: OutlineInputBorder(),
                          suffix: Text("€"))),
                  const SizedBox.square(dimension: 32),
                  if (hasChanges) ...[
                    FilledButton.icon(
                      onPressed: _saveChanges,
                      label: const Text("Save changes"),
                      icon: const Icon(Icons.check),
                    ),
                    const SizedBox.square(dimension: 4),
                    ElevatedButton.icon(
                      onPressed: _cancelChanges,
                      label: const Text("Cancel Changes"),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                  const SizedBox.square(dimension: 16),
                ]),
          )),
        ));
  }

  void _saveChanges() {
    FocusManager.instance.primaryFocus?.unfocus();
    BlocProvider.of<BudgetManagerBloc>(context).add(
        UpdateDailyExpenseAllocation(
            amount:
                double.tryParse(_dailyAllocationTextController.text.trim()) ??
                    0));
  }

  void _cancelChanges() {
    FocusManager.instance.primaryFocus?.unfocus();
    _dailyAllocationTextController.text =
        (BlocProvider.of<BudgetManagerBloc>(context).state as DetailedBudget)
            .dailyExpenseAllocation
            .amount
            .toString();
    setState(() {});
  }
}
