import 'dart:developer';

import 'package:crypto_bank/configs/app_settings.dart';
import 'package:crypto_bank/models/coin_model.dart';
import 'package:crypto_bank/pages/coin_detail_page.dart';
import 'package:crypto_bank/repositories/coins_repositories.dart';
import 'package:crypto_bank/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinsPage extends StatefulWidget {
  const CoinsPage({Key? key}) : super(key: key);

  @override
  State<CoinsPage> createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
  final table = CoinRepository.table;
  late FavoritesRepository favorites;
  List<CoinModel> selecteds = [];

  late NumberFormat real;
  late Map<String, String> loc;

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  changeLanguageButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$';

    return PopupMenuButton(
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.swap_vert),
            title: Text('Usar $locale'),
            onTap: () {
              context.read<AppSettings>().setLocale(locale, name);
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  clearSelecteds() {
    setState(() {
      selecteds = [];
    });
  }

  AppBar appBarSelect() {
    if (selecteds.isEmpty) {
      return AppBar(
        actions: [changeLanguageButton()],
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
        actions: [changeLanguageButton()],
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
    // favorite = Provider.of<FavoritesRepository>(context);
    favorites = context.watch<FavoritesRepository>();
    readNumberFormat();
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
              title: Row(
                children: [
                  Text(
                    table[coin].name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  if (favorites.list.contains(table[coin]))
                    const Icon(Icons.star, color: Colors.amber, size: 10)
                ],
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
      floatingActionButton: selecteds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                favorites.saveAll(selecteds);
                clearSelecteds();
              },
              icon: const Icon(Icons.star),
              label: const Text(
                "FAVORITAR",
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
