import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jebud_app/components/add_budget_element.dart';
import 'package:jebud_app/components/settings.dart';

import '../components/month_summary.dart';

class MyHomePage extends StatefulWidget {
  static const String name = "/home";

  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabController.index,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.calculate_outlined), label: "Summary"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
        onDestinationSelected: (newIndex) {
          setState(() {
            _tabController.animateTo(newIndex);
          });
        },
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const [MonthSummary(), Settings()],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => const AddBudgetElement(),
                    enableDrag: true,
                    useSafeArea: true);
              },
            )
          : null,
    );
  }
}
