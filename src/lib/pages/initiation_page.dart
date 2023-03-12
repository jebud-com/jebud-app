import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jebud_app/pages/home_page.dart';

class InitiationPage extends StatefulWidget {
  static const String name = "/init";
  const InitiationPage({super.key});

  @override
  State<StatefulWidget> createState() => _InitiationPageState();
}

class _InitiationPageState extends State<InitiationPage> {
  final TextEditingController _startingBudgetTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: BlocProvider.of<BudgetManagerBloc>(context),
        listener: (context, state) {
          if (state is DetailedBudget) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(MyHomePage.name, (_) => false);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).colorScheme.secondary,
              ),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
            ),
            extendBodyBehindAppBar: true,
            body: Padding(
                padding: const EdgeInsets.all(32),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      const SizedBox.square(dimension: 64),
                      Image.asset("assets/png/app_name_slogan.png",
                          height: 130, fit: BoxFit.contain),
                      SvgPicture.asset("assets/svg/illustrations/fill_form.svg",
                          height: 350),
                      const Text(
                        "To start your budgeting journey let's start by filling your starting budget",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox.square(dimension: 16),
                      TextFormField(
                          controller: _startingBudgetTextController,
                          textInputAction: TextInputAction.go,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^-?\d*\.?\d*')),
                          ],
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          decoration: const InputDecoration(
                              label: Text("Starting Budget"),
                              border: OutlineInputBorder(),
                              suffix: Text("€"))),
                      const SizedBox.square(dimension: 32),
                      ElevatedButton.icon(
                        onPressed: _addStartingBudget,
                        label: const Text("Let's get started!"),
                        icon: const Icon(Icons.arrow_forward),
                      ),
                      const SizedBox.square(dimension: 32),
                    ])))));
  }

  void _addStartingBudget() {
    BlocProvider.of<BudgetManagerBloc>(context).add(SetupBudgetDetails(
        startingAmount:
            double.parse(_startingBudgetTextController.text.trim())));
  }
}
