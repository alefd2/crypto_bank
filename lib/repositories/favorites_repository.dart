import 'dart:collection';

import 'package:crypto_bank/models/coin_model.dart';
import 'package:flutter/material.dart';

class FavoritesRepository extends ChangeNotifier {
  final List<CoinModel> _list = [];

  UnmodifiableListView<CoinModel> get list => UnmodifiableListView(_list);

  saveAll(List<CoinModel> coins) {
    for (var coin in coins) {
      if (!_list.contains(coin)) _list.add(coin);
    }
    notifyListeners();
  }

  remove(CoinModel coin) {
    _list.remove(coin);
    notifyListeners();
  }
}
