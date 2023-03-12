import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:jebud_app/pages/home_page.dart';
import 'package:jebud_app/pages/splash_screen.dart';
import 'pages/initiation_page.dart';

void main() async {
  var budgetRepository = BudgetRepositoryImpl("jebud_db");
  await budgetRepository.init();

  runApp(
      MyApp(() => BudgetManagerBloc(budgetRepository, DateTimeServiceImpl())));
}

class MyApp extends StatelessWidget {
  final BudgetManagerBloc Function() budgetManagerBlocBuilder;

  const MyApp(this.budgetManagerBlocBuilder, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => budgetManagerBlocBuilder(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: const Color(0xff2b0548),
            colorScheme: const ColorScheme.highContrastLight(
                primary: Color(0xff2b0548),
                onSecondary: Colors.white,
                secondary: Color(0xff4630ab)),
          ),
          home: const SplashScreen(),
          routes: {
            InitiationPage.name: (_) => const InitiationPage(),
            MyHomePage.name: (_) => const MyHomePage()
          },
        ));
  }
}
