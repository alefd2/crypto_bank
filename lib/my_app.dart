import 'package:crypto_bank/pages/coins_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Bank',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const CoinsPage(),
    );
  }
}
