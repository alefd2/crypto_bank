import 'package:crypto_bank/models/coin_model.dart';

class PositionModel {
  CoinModel coin;
  double quantity;

  PositionModel({required this.coin, required this.quantity});
}
