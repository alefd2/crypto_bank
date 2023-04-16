import 'package:crypto_bank/database/db.dart';
import 'package:crypto_bank/models/position_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AccountRepository extends ChangeNotifier {
  late Database db;
  List<PositionModel> _wallet = [];
  double _balance = 0;

  get balance => _balance;
  List<PositionModel> get wallet => _wallet;

  AccountRepository() {
    _iniRepository();
  }

  _iniRepository() async {
    await _getBalance();
  }

  _getBalance() async {
    db = await DB.instance.database;

    List account = await db.query('account', limit: 1);

    _balance = account.first['balance'];
    notifyListeners();
  }

  setBalance(double value) async {
    db = await DB.instance.database;
    db.update('account', {"balance": value});
    _balance = value;
    notifyListeners();
  }
}
