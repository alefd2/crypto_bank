import 'package:crypto_bank/repositories/favorites_repository.dart';
import 'package:crypto_bank/widget/moeda_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Favoritas"),
        ),
      ),
      body: Consumer<FavoritesRepository>(
        builder: (context, favorites, child) {
          return favorites.list.isEmpty
              ? const ListTile(
                  leading: Icon(Icons.star),
                  title: Text("Ainda não há moedas favoritas"),
                )
              : ListView.builder(
                  itemCount: favorites.list.length,
                  itemBuilder: (_, index) {
                    return CoinCard(coin: favorites.list[index]);
                  },
                );
        },
      ),
    );
  }
}
