import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jebud_app/pages/home_page.dart';
import 'package:jebud_app/pages/initiation_page.dart';

import '../components/animated_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    BlocProvider.of<BudgetManagerBloc>(context).add(InitializeBudget());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: BlocProvider.of<BudgetManagerBloc>(context),
        listener: (context, state) {
          if (state is EmptyBudget) {
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(InitiationPage.name, (_) => false);
            });
          } else if (state is DetailedBudget) {
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(MyHomePage.name, (_) => false);
            });
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).colorScheme.secondary,
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          body: const Center(child: AnimatedLogo()),
        ));
  }
}
