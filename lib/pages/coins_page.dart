import 'dart:developer';

import 'package:crypto_bank/models/coin_model.dart';
import 'package:crypto_bank/repositories/coins_repositories.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CoinsPage extends StatefulWidget {
  const CoinsPage({Key? key}) : super(key: key);

  @override
  State<CoinsPage> createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
  final table = CoinRepository.table;
  NumberFormat real = NumberFormat.compactCurrency(
      locale: "pt-BR", decimalDigits: 2, name: "R\$");

  List<CoinModel> selecteds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Crypto moedas"),
        ),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int coin) {
            return ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              leading: (selecteds.contains(table[coin]))
                  ? const CircleAvatar(
                      child: Icon(Icons.check),
                    )
                  : SizedBox(
                      width: 40,
                      child: Image.asset(table[coin].icone),
                    ),
              title: Text(
                table[coin].name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(table[coin].acronym),
              trailing: Text(
                real.format(table[coin].price),
              ),
              selected: selecteds.contains(table[coin]),
              selectedTileColor: Colors.indigo[50],
              onLongPress: () {
                setState(() {
                  (selecteds.contains(table[coin]))
                      ? selecteds.remove(table[coin])
                      : selecteds.add(table[coin]);
                });
                log(table[coin].name);
              },
            );
          },
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: table.length),
    );
  }
}
