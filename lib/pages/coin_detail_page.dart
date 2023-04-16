import 'package:crypto_bank/models/coin_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show NumberFormat;

class CoinDetailsPage extends StatefulWidget {
  final CoinModel coin;

  const CoinDetailsPage({Key? key, required this.coin}) : super(key: key);

  @override
  State<CoinDetailsPage> createState() => _CoinDetailsPageState();
}

class _CoinDetailsPageState extends State<CoinDetailsPage> {
  final _form = GlobalKey<FormState>();
  final _valor = TextEditingController();

  NumberFormat real = NumberFormat.compactCurrency(
      locale: "pt-BR", decimalDigits: 2, name: "R\$");

  double quantity = 0.0;

  void purchase() {
    if (_form.currentState!.validate()) {
      // salvar compra
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Compra realizada com sucesso!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name.toString()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 22, top: 22),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Image.asset(widget.coin.icone),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    real.format(widget.coin.price),
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(color: Colors.teal.withOpacity(0.05)),
                child: Text(
                  '$quantity ${widget.coin.acronym}',
                  style: const TextStyle(fontSize: 20, color: Colors.teal),
                ),
              ),
            ),
            Form(
              key: _form,
              child: TextFormField(
                controller: _valor,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Valor",
                  prefixIcon: Icon(
                    Icons.monetization_on_outlined,
                  ),
                  suffix: Text(
                    "reais",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informa o valor da compra';
                  } else if (double.parse(value) < 50) {
                    return 'Compara mínima é R\$50';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    quantity = (value.isEmpty)
                        ? 0
                        : double.parse(value) / widget.coin.price;
                  });
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: purchase,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Comprar",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
