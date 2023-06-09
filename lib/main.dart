import 'package:crypto_bank/configs/app_settings.dart';
import 'package:crypto_bank/my_app.dart';
import 'package:crypto_bank/repositories/account_repository.dart';
import 'package:crypto_bank/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountRepository()),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => FavoritesRepository())
      ],
      child: const MyApp(),
    ),
  );
}
