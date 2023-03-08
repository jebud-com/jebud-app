import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class InitiationPage extends StatefulWidget {
  const InitiationPage({super.key});

  @override
  State<StatefulWidget> createState() => _InitiationPageState();
}

class _InitiationPageState extends State<InitiationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        onPressed: () {},
                        label: const Text("Let's get started!"),
                        icon: const Icon(Icons.arrow_forward),
                      ),
                      const SizedBox.square(dimension: 32),
                    ]))));
  }
}
