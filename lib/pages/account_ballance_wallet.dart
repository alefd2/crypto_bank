import 'package:crypto_bank/configs/app_settings.dart';
import 'package:crypto_bank/models/position_model.dart';
import 'package:crypto_bank/repositories/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int index = 0;
  double totalWallet = 0;
  double balanceWallet = 0;
  late NumberFormat real;
  late Map<String, String> loc;
  late AccountRepository account;

  double graficValue = 0;
  String graficoLabel = '';
  List<PositionModel> wallet = [];

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  loadWallet() {
    setGraficData(index);
    wallet = account.wallet;
    final lengthWallet = wallet.length + 1;

    return List.generate(lengthWallet, (i) {
      final isTouched = i == index;
      final isBalance = i == lengthWallet - 1;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = isTouched ? Colors.tealAccent : Colors.tealAccent[100];

      double percent = 0;

      if (!isBalance) {
        percent = wallet[i].coin.price * wallet[i].quantity / totalWallet;
      } else {
        percent = (account.balance > 0) ? account.balance / totalWallet : 0;
      }

      percent *= 100;

      return PieChartSectionData(
        color: color,
        value: percent,
        title: percent.toStringAsFixed(0),
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.black87),
      );
    });
  }

  setGraficData(int index) {
    if (index > 0) return;

    if (index == wallet.length) {
      graficoLabel = 'Saldo';
      graficValue = account.balance;
    } else {
      graficoLabel = wallet[index].coin.name;
      graficValue = wallet[index].coin.price * wallet[index].quantity;
    }
  }

  loadGrafic() {
    return (account.balance <= 0)
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: const Center(child: CircularProgressIndicator()),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      sectionsSpace: 5,
                      centerSpaceRadius: 110,
                      sections: loadWallet(),
                      pieTouchData: PieTouchData(
                        touchCallback: (touch) {
                          setState(() {
                            index = touch.touchedSection!.touchedSectionIndex;
                            setGraficData(index);
                          });
                        },
                      )),
                ),
              ),
              Column(
                children: [
                  Text(
                    graficoLabel,
                    style: const TextStyle(fontSize: 20, color: Colors.teal),
                  ),
                  Text(
                    real.format(
                      graficValue,
                    ),
                    style: const TextStyle(fontSize: 20, color: Colors.teal),
                  )
                ],
              )
            ],
          );
  }

  setTotalWallet() {
    final walletList = account.wallet;
    setState(() {
      totalWallet = account.balance;
      for (var position in walletList) {
        totalWallet += position.coin.price * position.quantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    readNumberFormat();
    account = context.watch<AccountRepository>();
    balanceWallet = account.balance;
    setTotalWallet();
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 48, bottom: 8),
              child: Text(
                "Valor da carteira",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Text(
              real.format(totalWallet),
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.5),
            ),
            loadGrafic(),
          ],
        ),
      ),
    );
  }
}
