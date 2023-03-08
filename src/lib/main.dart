import 'package:flutter/material.dart';
import 'pages/initiation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xff2b0548),
        colorScheme: const ColorScheme.highContrastLight(
            primary: Color(0xff2b0548),
            onSecondary: Colors.white,
            secondary: Color(0xff4630ab)),
      ),
      home: const InitiationPage(),
    );
  }
}

