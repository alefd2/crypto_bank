import 'package:crypto_bank/my_app.dart';
import 'package:crypto_bank/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesRepository(),
      child: const MyApp(),
    ),
  );
}
