import 'dart:developer';

import 'package:crypto_bank/models/coin_model.dart';
import 'package:crypto_bank/pages/coin_detail_page.dart';
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

  AppBar appBarSelect() {
    if (selecteds.isEmpty) {
      return AppBar(
        title: const Center(
          child: Text('Cripto moedas'),
        ),
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selecteds = [];
            });
          },
        ),
        title: Center(
          child: Text(
            "${selecteds.length} selecionadas",
          ),
        ),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
            color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      );
    }
  }

  FloatingActionButton? floatingActionButtonState() {
    if (selecteds.isNotEmpty) {
      return FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.star),
        label: const Text(
          "FAVORITAR",
          style: TextStyle(
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return null;
    }
  }

  showDetails(coin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinDetailsPage(coin: coin),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarSelect(),
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
                onTap: () => showDetails(table[coin]),
              );
            },
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: table.length),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: floatingActionButtonState());
  }
}
