import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/month_summary.dart';

class MyHomePage extends StatefulWidget {
  static const String name = "/home";
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late final TabController _tabController;

  @override
  void initState() {
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: _selectedIndex);
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
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.calculate_outlined), label: "Summary"),
          NavigationDestination(
              icon: Icon(Icons.question_mark), label: "WhatIf"),
        ],
        onDestinationSelected: (newIndex) {
          if (newIndex == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Coming soon :)'),
              ),
            );
            return;
          }
          setState(() {
            _selectedIndex = newIndex;
            _tabController.animateTo(_selectedIndex);
          });
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [MonthSummary(), Text("")],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (_) => Container(), enableDrag: true);
        },
      ),
    );
  }
}
