import 'package:crypto_bank/pages/account_ballance_wallet.dart';
import 'package:crypto_bank/pages/coins_page.dart';
import 'package:crypto_bank/pages/settings_page.dart';
import 'package:flutter/material.dart';

import 'favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  late PageController pc;

  setCurrentPage(page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: const [
          CoinsPage(),
          FavoritePage(),
          WalletPage(),
          SettingsPage(),
        ],
        onPageChanged: (page) => setCurrentPage(page),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Lista"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favoritas"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: "Carteira"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Configurações"),
        ],
        onTap: (page) {
          pc.animateToPage(page,
              duration: const Duration(milliseconds: 400), curve: Curves.ease);
        },
      ),
    );
  }
}
