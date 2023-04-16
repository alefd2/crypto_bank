import 'package:crypto_bank/configs/app_settings.dart';
import 'package:crypto_bank/repositories/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> updateBalance() async {
    final form = GlobalKey<FormState>();
    final value = TextEditingController();
    final account = context.read<AccountRepository>();

    value.text = account.balance.toString();

    AlertDialog dialog = AlertDialog(
      title: const Text("Atualizar o saldo"),
      content: Form(
        key: form,
        child: TextFormField(
          controller: value,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*')),
          ],
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informa o valor do saldo';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            if (form.currentState!.validate()) {
              account.setBalance(double.parse(value.text));
              Navigator.pop(context);
            }
          },
          child: const Text("Salvar"),
        )
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountRepository>();
    final loc = context.watch<AppSettings>().locale;
    NumberFormat real =
        NumberFormat.currency(locale: loc['locale'], name: loc['name']);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Conta"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              title: const Text("Saldo"),
              subtitle: Text(
                real.format(account.balance),
                style: const TextStyle(fontSize: 25, color: Colors.indigo),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  updateBalance();
                },
              ),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
